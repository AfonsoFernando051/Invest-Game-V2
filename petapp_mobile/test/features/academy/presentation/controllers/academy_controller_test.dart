import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_recommendation.dart';
import 'package:petrimonium/features/academy/domain/entities/mastery_tier.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';
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

  test('a completed lesson answered imperfectly shows lower Mastery than Progress', () async {
    await repository.markLessonCompleted('foundations_what_is_investing');
    final module = AcademyCatalog.moduleById('investor_foundations')!;
    final school = AcademyCatalog.schoolById(module.schoolId)!;
    final controller = AcademyController(repository: repository);

    await controller.load();

    expect(controller.realMasteryFor(school), lessThan(controller.masteryFor(school)));
    expect(controller.masteryTierFor(school), isNot(MasteryTier.mastering));
  });

  test('a lesson answered perfectly counts fully toward Mastery', () async {
    await repository.markLessonCompleted('foundations_what_is_investing');
    await repository.markLessonPerfect('foundations_what_is_investing');
    final module = AcademyCatalog.moduleById('investor_foundations')!;
    final school = AcademyCatalog.schoolById(module.schoolId)!;
    final controller = AcademyController(repository: repository);

    await controller.load();

    expect(controller.realMasteryFor(school), controller.masteryFor(school));
  });

  test('recommendations surface a review item once a lesson is completed but not perfect', () async {
    await repository.markLessonCompleted('foundations_what_is_investing');
    final controller = AcademyController(repository: repository);

    await controller.load();

    expect(controller.recommendations.map((r) => r.type), contains(RecommendationType.review));
    expect(controller.reviewQueue.map((l) => l.id), contains('foundations_what_is_investing'));
    expect(controller.reviewEstimatedMinutes, greaterThanOrEqualTo(1));
  });

  test('review queue is empty when nothing has been completed', () async {
    final controller = AcademyController(repository: repository);

    await controller.load();

    expect(controller.reviewQueue, isEmpty);
    expect(controller.reviewEstimatedMinutes, 0);
  });
}
