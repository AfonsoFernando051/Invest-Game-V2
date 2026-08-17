import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:petrimonium/core/constants/api_constants.dart';
import 'package:petrimonium/core/network/api_client.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockHttpClient httpClient;
  late MockSecureStorage secureStorage;
  late ApiClient apiClient;

  setUpAll(() {
    registerFallbackValue(Uri.parse('${ApiConstants.baseUrl}/fallback'));
  });

  setUp(() {
    httpClient = MockHttpClient();
    secureStorage = MockSecureStorage();
    apiClient = ApiClient(client: httpClient, secureStorage: secureStorage);

    final response = http.Response('{}', 200);
    when(() => httpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => response);
    when(() => httpClient.post(any(), headers: any(named: 'headers'), body: any(named: 'body')))
        .thenAnswer((_) async => response);
    when(() => httpClient.put(any(), headers: any(named: 'headers'), body: any(named: 'body')))
        .thenAnswer((_) async => response);
  });

  group('ApiClient token storage', () {
    test('saveToken writes under the shared auth token key', () async {
      when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      await apiClient.saveToken('token-123');

      verify(() => secureStorage.write(key: ApiClient.authTokenKey, value: 'token-123')).called(1);
    });

    test('readToken reads under the shared auth token key', () async {
      when(() => secureStorage.read(key: any(named: 'key'))).thenAnswer((_) async => 'stored-token');

      final token = await apiClient.readToken();

      expect(token, 'stored-token');
      verify(() => secureStorage.read(key: ApiClient.authTokenKey)).called(1);
    });

    test('clearToken deletes under the shared auth token key', () async {
      when(() => secureStorage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      await apiClient.clearToken();

      verify(() => secureStorage.delete(key: ApiClient.authTokenKey)).called(1);
    });
  });

  group('ApiClient request headers', () {
    test('get attaches a Bearer token when one is stored', () async {
      when(() => secureStorage.read(key: any(named: 'key'))).thenAnswer((_) async => 'abc123');

      await apiClient.get('/investments');

      final captured = verify(() => httpClient.get(captureAny(), headers: captureAny(named: 'headers'))).captured;
      final url = captured[0] as Uri;
      final headers = captured[1] as Map<String, String>;

      expect(url.toString(), '${ApiConstants.baseUrl}/investments');
      expect(headers['Authorization'], 'Bearer abc123');
      expect(headers['Content-Type'], 'application/json');
    });

    test('get omits the Authorization header when no token is stored', () async {
      when(() => secureStorage.read(key: any(named: 'key'))).thenAnswer((_) async => null);

      await apiClient.get('/investments');

      final captured = verify(() => httpClient.get(captureAny(), headers: captureAny(named: 'headers'))).captured;
      final headers = captured[1] as Map<String, String>;

      expect(headers.containsKey('Authorization'), isFalse);
    });

    test('post sends a JSON-encoded body with the auth header', () async {
      when(() => secureStorage.read(key: any(named: 'key'))).thenAnswer((_) async => 'abc123');

      await apiClient.post('/investments', {'ticker': 'PETR4'});

      final captured = verify(() => httpClient.post(
            captureAny(),
            headers: captureAny(named: 'headers'),
            body: captureAny(named: 'body'),
          )).captured;

      expect((captured[0] as Uri).toString(), '${ApiConstants.baseUrl}/investments');
      expect((captured[1] as Map<String, String>)['Authorization'], 'Bearer abc123');
      expect(captured[2], '{"ticker":"PETR4"}');
    });

    test('put sends a JSON-encoded body with the auth header', () async {
      when(() => secureStorage.read(key: any(named: 'key'))).thenAnswer((_) async => 'abc123');

      await apiClient.put('/settings', {'language': 'en'});

      final captured = verify(() => httpClient.put(
            captureAny(),
            headers: captureAny(named: 'headers'),
            body: captureAny(named: 'body'),
          )).captured;

      expect((captured[0] as Uri).toString(), '${ApiConstants.baseUrl}/settings');
      expect(captured[2], '{"language":"en"}');
    });
  });
}
