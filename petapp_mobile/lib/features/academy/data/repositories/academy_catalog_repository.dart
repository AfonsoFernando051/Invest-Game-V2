import 'dart:convert';

import 'package:petrimonium/core/constants/api_constants.dart';
import 'package:petrimonium/core/network/api_client.dart';
import 'package:petrimonium/core/network/api_error_parser.dart';
import 'package:petrimonium/features/academy/data/models/academy_catalog_snapshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fetches the Academy catalog from the backend and caches it locally, one
/// entry per language — the backend is the source of truth (see
/// `docs/DECISIONS.md`), and the cache exists purely so the app can render
/// instantly from the last-known snapshot and work offline after a first
/// successful fetch. The raw response body is cached verbatim (not the
/// re-serialized model), so a cache round-trip is byte-identical to what
/// the backend actually sent.
class AcademyCatalogRepository {
  AcademyCatalogRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  static String _cacheKey(String lang) => 'academy_catalog_cache_$lang';

  /// The last snapshot fetched for [lang], if any — instantaneous, no
  /// network. `null` means this language has never been fetched
  /// successfully on this device.
  Future<AcademyCatalogSnapshot?> loadCached(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cacheKey(lang));
    if (raw == null) return null;
    return AcademyCatalogSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Fetches [lang]'s catalog from the backend and overwrites its cache
  /// entry. Throws on any network/HTTP failure — callers decide what to do
  /// with a stale-but-present cache vs. no cache at all (see
  /// `AcademyController.load`).
  Future<AcademyCatalogSnapshot> fetchAndCache(String lang) async {
    final response = await _apiClient.get('${ApiConstants.academyCatalogEndpoint}?lang=$lang');
    if (response.statusCode != 200) {
      throw Exception(
        extractErrorDetail(response, fallback: 'Failed to load academy catalog. Status Code: ${response.statusCode}'),
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey(lang), response.body);
    return AcademyCatalogSnapshot.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
