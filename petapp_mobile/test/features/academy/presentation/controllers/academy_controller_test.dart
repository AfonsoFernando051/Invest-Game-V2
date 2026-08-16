import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/presentation/controllers/academy_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAcademyRemoteDataSource extends Mock implements AcademyRemoteDataSource {}

void main() {
  late AcademyProgressLocalRepository repository;
  late MockAcademyRemoteDataSource mockRemoteDataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = AcademyProgressLocalRepository();
    mockRemoteDataSource = MockAcademyRemoteDataSource();
  });

  test('load() works with local progress alone when no remote datasource is provided', () async {
    await repository.markLessonCompleted('foundations_what_is_investing');
    final controller = AcademyController(repository: repository);

    await controller.load();

    expect(controller.completedLessonIds, {'foundations_what_is_investing'});
    expect(controller.isLoading, isFalse);
  });

  test('load() merges server-reported completions into local progress', () async {
    await repository.markLessonCompleted('foundations_what_is_investing');
    when(() => mockRemoteDataSource.getCompletedLessonIds())
        .thenAnswer((_) async => {'foundations_what_is_investing', 'foundations_inflation'});
    final controller = AcademyController(repository: repository, remoteDataSource: mockRemoteDataSource);

    await controller.load();

    expect(controller.completedLessonIds, {'foundations_what_is_investing', 'foundations_inflation'});
    final persisted = await repository.loadCompletedLessonIds();
    expect(persisted, {'foundations_what_is_investing', 'foundations_inflation'});
  });

  test('load() keeps local-only progress when the remote sync fails (offline)', () async {
    await repository.markLessonCompleted('foundations_what_is_investing');
    when(() => mockRemoteDataSource.getCompletedLessonIds()).thenThrow(Exception('offline'));
    final controller = AcademyController(repository: repository, remoteDataSource: mockRemoteDataSource);

    await controller.load();

    expect(controller.completedLessonIds, {'foundations_what_is_investing'});
    expect(controller.isLoading, isFalse);
  });
}
