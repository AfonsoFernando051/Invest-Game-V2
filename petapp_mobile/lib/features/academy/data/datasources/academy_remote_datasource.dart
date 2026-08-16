import 'dart:convert';
import 'package:petrimonium/core/constants/api_constants.dart';
import 'package:petrimonium/core/network/api_client.dart';
import 'package:petrimonium/core/network/api_error_parser.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson_completion_result.dart';

/// Syncs Academy lesson completions against the backend's authoritative
/// learning/XP ledger (see `docs/ACADEMY_ENGINE.md`, `docs/DECISIONS.md`
/// DECISION-014). Callers use this best-effort — a failed/offline sync must
/// never block the local lesson-completion flow, which stays the source of
/// truth for the in-session UI regardless of connectivity.
class AcademyRemoteDataSource {
  final ApiClient apiClient;

  AcademyRemoteDataSource({required this.apiClient});

  /// Returns the backend's authoritative XP/level for this user after the
  /// completion — never fabricated client-side.
  Future<LessonCompletionResult> completeLesson(String lessonId) async {
    final response = await apiClient.post(ApiConstants.learningLessonCompleteEndpoint(lessonId), {});
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        extractErrorDetail(response, fallback: 'Failed to sync lesson completion. Status Code: ${response.statusCode}'),
      );
    }
    return LessonCompletionResult.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// The set of lesson ids the backend has recorded as completed for the
  /// current user — used to reconcile local storage across devices.
  Future<Set<String>> getCompletedLessonIds() async {
    final response = await apiClient.get(ApiConstants.learningProgressEndpoint);
    if (response.statusCode != 200) {
      throw Exception(
        extractErrorDetail(response, fallback: 'Failed to load learning progress. Status Code: ${response.statusCode}'),
      );
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final ids = data['completedLessonIds'] as List<dynamic>? ?? const [];
    return ids.map((id) => id.toString()).toSet();
  }
}
