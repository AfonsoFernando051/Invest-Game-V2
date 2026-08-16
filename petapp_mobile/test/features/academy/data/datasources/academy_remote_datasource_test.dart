import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:petrimonium/core/constants/api_constants.dart';
import 'package:petrimonium/core/network/api_client.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late AcademyRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AcademyRemoteDataSource(apiClient: mockApiClient);
  });

  group('AcademyRemoteDataSource.completeLesson', () {
    const tLessonId = 'foundations_what_is_investing';

    test('succeeds silently on 200', () async {
      when(() => mockApiClient.post(any(), any())).thenAnswer((_) async => http.Response('{}', 200));

      await dataSource.completeLesson(tLessonId);

      verify(() => mockApiClient.post(
            ApiConstants.learningLessonCompleteEndpoint(tLessonId),
            {},
          )).called(1);
    });

    test('throws with the backend detail on a non-2xx response', () async {
      when(() => mockApiClient.post(any(), any())).thenAnswer(
        (_) async => http.Response(jsonEncode({'detail': 'Unknown lesson id: foo'}), 400),
      );

      await expectLater(
        () => dataSource.completeLesson(tLessonId),
        throwsA(predicate((e) => e is Exception && e.toString().contains('Unknown lesson id: foo'))),
      );
    });
  });

  group('AcademyRemoteDataSource.getCompletedLessonIds', () {
    test('returns the completed lesson ids from the response body', () async {
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => http.Response(
          jsonEncode({
            'completedLessonIds': ['foundations_what_is_investing', 'foundations_inflation'],
            'completedModuleIds': [],
            'totalXp': 40,
            'level': 1,
            'xpIntoLevel': 40,
            'xpForNextLevel': 50,
          }),
          200,
        ),
      );

      final result = await dataSource.getCompletedLessonIds();

      expect(result, {'foundations_what_is_investing', 'foundations_inflation'});
      verify(() => mockApiClient.get(ApiConstants.learningProgressEndpoint)).called(1);
    });

    test('throws on a non-200 response', () async {
      when(() => mockApiClient.get(any())).thenAnswer((_) async => http.Response('Unauthorized', 401));

      await expectLater(
        () => dataSource.getCompletedLessonIds(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
