import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:petrimonium/core/constants/api_constants.dart';

class ApiClient {
  final http.Client _client;
  final FlutterSecureStorage _secureStorage;

  /// [client]/[secureStorage] are injectable so tests can substitute mocks —
  /// production code relies on the defaults.
  ApiClient({http.Client? client, FlutterSecureStorage? secureStorage})
      : _client = client ?? http.Client(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Key under which the bearer token is stored. Moved off
  /// `shared_preferences` (which persists as unencrypted plaintext on disk)
  /// onto the platform keystore/keychain via `flutter_secure_storage`, since
  /// this value grants full account access.
  static const String authTokenKey = 'auth_token';

  Future<String?> readToken() => _secureStorage.read(key: authTokenKey);

  Future<void> saveToken(String token) => _secureStorage.write(key: authTokenKey, value: token);

  Future<void> clearToken() => _secureStorage.delete(key: authTokenKey);

  Future<Map<String, String>> _getHeaders() async {
    final token = await readToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> post(String endpoint, dynamic body) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    return _client.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    return _client.get(
      url,
      headers: headers,
    );
  }

  Future<http.Response> put(String endpoint, dynamic body) async {
    final headers = await _getHeaders();
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');

    return _client.put(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}
