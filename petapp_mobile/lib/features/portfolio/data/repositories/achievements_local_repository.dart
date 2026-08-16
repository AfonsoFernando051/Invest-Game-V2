import 'package:shared_preferences/shared_preferences.dart';

/// A local, offline-fallback cache of unlocked achievement ids + their
/// unlock timestamp. The backend (`AchievementsRepository.evaluate()`) is
/// now the source of truth — every successful evaluation overwrites this
/// cache with the server's authoritative state via [cacheUnlocked]. This
/// class only exists so the UI has something real to show if the app opens
/// offline; it never decides what's unlocked on its own.
class AchievementsLocalRepository {
  static const _idsKey = 'achievements_unlocked_ids';
  static const _datesKey = 'achievements_unlocked_dates';

  Future<Map<String, DateTime>> loadUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_idsKey) ?? const [];
    final dates = prefs.getStringList(_datesKey) ?? const [];

    final result = <String, DateTime>{};
    for (var i = 0; i < ids.length && i < dates.length; i++) {
      final parsed = DateTime.tryParse(dates[i]);
      if (parsed != null) result[ids[i]] = parsed;
    }
    return result;
  }

  /// Overwrites the local cache with the backend's authoritative unlocked
  /// map. Safe as a plain overwrite (not a merge) because achievements are
  /// permanent — the server's set never shrinks.
  Future<void> cacheUnlocked(Map<String, DateTime> unlockedAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_idsKey, unlockedAt.keys.toList());
    await prefs.setStringList(_datesKey, unlockedAt.values.map((d) => d.toIso8601String()).toList());
  }
}
