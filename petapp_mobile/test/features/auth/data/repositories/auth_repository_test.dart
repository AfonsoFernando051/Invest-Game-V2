import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrimonium/core/network/api_client.dart';
import 'package:petrimonium/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:petrimonium/features/auth/data/repositories/auth_repository.dart';
import 'package:petrimonium/features/auth/data/models/user_model.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockApiClient mockApiClient;
  late AuthRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    when(() => mockRemoteDataSource.apiClient).thenReturn(mockApiClient);
    when(() => mockApiClient.saveToken(any())).thenAnswer((_) async {});
    when(() => mockApiClient.readToken()).thenAnswer((_) async => null);
    when(() => mockApiClient.clearToken()).thenAnswer((_) async {});
    repository = AuthRepository(remoteDataSource: mockRemoteDataSource);
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthRepository', () {
    final tName = 'Test User';
    final tEmail = 'test@example.com';
    final tPassword = 'password123';
    final tToken = 'mock_token';
    final tUserModel = UserModel(email: tEmail, token: tToken);

    test('should call login on remote data source and save the token via ApiClient (secure storage)', () async {
      // arrange
      when(() => mockRemoteDataSource.login(any(), any()))
          .thenAnswer((_) async => tUserModel);

      // act
      await repository.login(tEmail, tPassword);

      // assert
      verify(() => mockRemoteDataSource.login(tEmail, tPassword)).called(1);
      verify(() => mockApiClient.saveToken(tToken)).called(1);
    });

    test('should call remoteDataSource.register and save the token via ApiClient when register is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.register(any(), any(), any()))
          .thenAnswer((_) async => UserModel(email: tEmail, token: tToken));

      // act
      await repository.register(tName, tEmail, tPassword);

      // assert
      verify(() => mockRemoteDataSource.register(tName, tEmail, tPassword)).called(1);
      verify(() => mockApiClient.saveToken(tToken)).called(1);
    });

    test('should call requestPasswordReset on remote data source', () async {
      when(() => mockRemoteDataSource.requestPasswordReset(any())).thenAnswer((_) async {});

      await repository.requestPasswordReset(tEmail);

      verify(() => mockRemoteDataSource.requestPasswordReset(tEmail)).called(1);
    });

    test('should call resetPassword on remote data source', () async {
      when(() => mockRemoteDataSource.resetPassword(any(), any())).thenAnswer((_) async {});

      await repository.resetPassword('reset-token', tPassword);

      verify(() => mockRemoteDataSource.resetPassword('reset-token', tPassword)).called(1);
    });

    test('should return true if isLoggedIn when a token exists in secure storage', () async {
      // arrange
      when(() => mockApiClient.readToken()).thenAnswer((_) async => tToken);

      // act
      final result = await repository.isLoggedIn();

      // assert
      expect(result, isTrue);
    });

    test('should return false if isLoggedIn when token is null', () async {
      // act
      final result = await repository.isLoggedIn();

      // assert
      expect(result, isFalse);
    });

    test('should clear the token via ApiClient and the saved email on logout', () async {
      // arrange
      SharedPreferences.setMockInitialValues({'auth_email': tEmail});

      // act
      await repository.logout();

      // assert
      verify(() => mockApiClient.clearToken()).called(1);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_email'), isNull);
    });
  });
}
