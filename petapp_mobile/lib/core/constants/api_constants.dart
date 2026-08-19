import 'package:flutter/foundation.dart';

class ApiConstants {
  // Overridable per build without editing source, e.g.:
  //   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8081   (Android emulator)
  //   flutter build apk --dart-define=API_BASE_URL=https://api.example.com  (prod)
  // Defaults to http://localhost:8081, which works for iOS Simulator/Web but
  // NOT the Android emulator (use 10.0.2.2 there) — see README.md.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8081',
  );

  static const String _devDefaultBaseUrl = 'http://localhost:8081';

  /// A release build that never received --dart-define=API_BASE_URL=... would otherwise
  /// silently ship pointed at a developer's own machine — fail loudly and immediately
  /// instead, rather than have every request quietly fail (or worse, quietly succeed against
  /// the wrong backend) in front of a real user.
  static void assertConfiguredForRelease() {
    if (kReleaseMode && baseUrl == _devDefaultBaseUrl) {
      throw StateError(
        'API_BASE_URL was not set for this release build — it would point at '
        'localhost. Build with --dart-define=API_BASE_URL=<real backend URL>.',
      );
    }
  }

  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';

  static const String onboardingQuestionsEndpoint = '/api/onboarding/questions';
  static const String onboardingSubmitEndpoint = '/api/onboarding/submit';
  static const String onboardingStatusEndpoint = '/api/onboarding/status';

  static const String settingsLanguageEndpoint = '/api/settings/language';

  static const String mentorChatEndpoint = '/api/mentor/chat';
  static const String mentorConversationsEndpoint = '/api/mentor/conversations';
  static String mentorConversationEndpoint(int id) => '/api/mentor/conversations/$id';

  static String learningLessonCompleteEndpoint(String lessonId) => '/api/v1/learning/lessons/$lessonId/complete';
  static const String learningProgressEndpoint = '/api/v1/learning/progress';
  static const String academyCatalogEndpoint = '/api/v1/academy/catalog';

  static const String gamificationSummaryEndpoint = '/api/v1/gamification/summary';
  static const String achievementsEndpoint = '/api/v1/achievements';
  static const String missionsEndpoint = '/api/v1/missions';
}
