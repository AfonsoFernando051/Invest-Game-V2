import 'package:shared_preferences/shared_preferences.dart';

/// Persists completed Academy lesson ids on-device. Mirrors
/// `AchievementsLocalRepository`'s style exactly: entries are only ever
/// added, never removed — completing a lesson is permanent, like unlocking
/// an achievement.
class AcademyProgressLocalRepository {
  static const _completedLessonIdsKey = 'academy_completed_lesson_ids';
  static const _perfectLessonIdsKey = 'academy_perfect_lesson_ids';

  Future<Set<String>> loadCompletedLessonIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_completedLessonIdsKey) ?? const []).toSet();
  }

  /// Lesson ids completed with every question answered correctly on the
  /// first try — the raw signal `MasteryCalculator` scores against. A subset
  /// of [loadCompletedLessonIds]'s result by construction.
  Future<Set<String>> loadPerfectLessonIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_perfectLessonIdsKey) ?? const []).toSet();
  }

  /// Marks [lessonId] as answered perfectly. Monotonic like
  /// [markLessonCompleted] — once perfect, always perfect, even if a later
  /// replay is missed — so Mastery can only improve via replay, never
  /// regress, matching this repository's existing "permanent, like unlocking
  /// an achievement" semantics.
  Future<Set<String>> markLessonPerfect(String lessonId) async {
    final existing = await loadPerfectLessonIds();
    if (existing.contains(lessonId)) return existing;

    final merged = {...existing, lessonId};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_perfectLessonIdsKey, merged.toList());
    return merged;
  }

  /// Adds [lessonId] to whatever was already persisted. A no-op if the
  /// lesson was already completed (replaying a lesson never re-grants XP).
  Future<Set<String>> markLessonCompleted(String lessonId) async {
    final existing = await loadCompletedLessonIds();
    if (existing.contains(lessonId)) return existing;

    final merged = {...existing, lessonId};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedLessonIdsKey, merged.toList());
    return merged;
  }

  /// Unions [serverLessonIds] into local storage — the same "only ever add,
  /// never remove" semantics as [markLessonCompleted]. Used to reconcile
  /// progress reported by the backend (e.g. completed on another device)
  /// without ever hiding a lesson completed locally but not yet synced.
  Future<Set<String>> mergeCompletedLessonIds(Set<String> serverLessonIds) async {
    final existing = await loadCompletedLessonIds();
    final merged = {...existing, ...serverLessonIds};
    if (merged.length == existing.length) return existing;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedLessonIdsKey, merged.toList());
    return merged;
  }

  /// A lightweight "recently struggling with this school" counter, used only
  /// to power the pet's difficulty-detected nudge (see
  /// `LessonSessionController`/`PetMessageCatalog.difficultyDetected`) — not
  /// a mistake-history log, no per-question detail is kept. Increments on
  /// every wrong answer in [schoolId] and resets on the next lesson
  /// completed there ([resetMisses]), so the signal only ever reflects
  /// recent struggle, not a permanent record.
  Future<int> recordMiss(String schoolId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _missCountKey(schoolId);
    final updated = (prefs.getInt(key) ?? 0) + 1;
    await prefs.setInt(key, updated);
    return updated;
  }

  Future<void> resetMisses(String schoolId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_missCountKey(schoolId));
  }

  String _missCountKey(String schoolId) => 'academy_miss_count_$schoolId';
}
