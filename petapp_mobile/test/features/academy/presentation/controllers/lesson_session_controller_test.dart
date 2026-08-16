import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson_completion_result.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson_step.dart';
import 'package:petrimonium/features/academy/presentation/controllers/lesson_session_controller.dart';
import 'package:petrimonium/features/pet/data/models/pet_specie_enum.dart';
import 'package:petrimonium/features/pet/domain/entities/pet_profile.dart';
import 'package:petrimonium/features/pet/domain/enums/accessory_type.dart';
import 'package:petrimonium/features/pet/domain/enums/pet_accessory_id.dart';
import 'package:petrimonium/features/pet/domain/enums/pet_evolution_stage.dart';
import 'package:petrimonium/features/pet/domain/repositories/mascot_repository.dart';
import 'package:petrimonium/features/pet/presentation/mascot/controllers/mascot_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAcademyRemoteDataSource extends Mock implements AcademyRemoteDataSource {}

/// Minimal in-memory MascotRepository double — this test only cares that
/// `evaluateEvolution` runs without needing real persistence.
class FakeMascotRepository implements MascotRepository {
  @override
  Future<PetProfile> loadProfile() async => PetProfile();

  @override
  Future<void> saveName(String name) async {}

  @override
  Future<void> saveStage(PetEvolutionStage stage) async {}

  @override
  Future<void> saveXp(int xp) async {}

  @override
  Future<void> saveSpecie(PetSpecieEnum specie) async {}

  @override
  Future<void> saveNetWorth(double netWorth) async {}

  @override
  Future<void> saveEquippedAccessories(Map<AccessoryType, PetAccessoryId> equipped) async {}

  @override
  Future<void> saveUnlockedAccessories(Set<PetAccessoryId> unlocked) async {}

  @override
  Future<void> saveLastActiveAt(DateTime lastActiveAt) async {}
}

void main() {
  setUpAll(() {
    registerFallbackValue('');
  });

  final lesson = const Lesson(
    id: 'test_lesson',
    moduleId: 'investor_foundations',
    title: 'Test Lesson',
    order: 1,
    xpReward: 20,
    steps: [SummaryStep(title: 'Done', takeaways: ['a'])],
  );

  late AcademyProgressLocalRepository academyRepository;
  late MascotController mascotController;
  late MockAcademyRemoteDataSource mockRemoteDataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    academyRepository = AcademyProgressLocalRepository();
    mascotController = MascotController(repository: FakeMascotRepository());
    mockRemoteDataSource = MockAcademyRemoteDataSource();
  });

  LessonSessionController buildController({AcademyRemoteDataSource? remoteDataSource}) {
    return LessonSessionController(
      lesson: lesson,
      academyRepository: academyRepository,
      mascotController: mascotController,
      academyRemoteDataSource: remoteDataSource,
    );
  }

  test('completes the lesson locally even when no remote datasource is provided', () async {
    final controller = buildController();

    await controller.advance();

    expect(controller.isComplete, isTrue);
    final completedIds = await academyRepository.loadCompletedLessonIds();
    expect(completedIds, contains('test_lesson'));
  });

  test('completes the lesson locally even when the remote sync fails (offline)', () async {
    when(() => mockRemoteDataSource.completeLesson(any())).thenThrow(Exception('offline'));
    final controller = buildController(remoteDataSource: mockRemoteDataSource);

    await controller.advance();

    expect(controller.isComplete, isTrue);
    final completedIds = await academyRepository.loadCompletedLessonIds();
    expect(completedIds, contains('test_lesson'));
  });

  test('syncs the completion to the backend when a remote datasource is available', () async {
    when(() => mockRemoteDataSource.completeLesson(any())).thenAnswer((_) async => const LessonCompletionResult(
          lessonId: 'test_lesson',
          alreadyCompleted: false,
          xpAwarded: 20,
          moduleCompleted: false,
          moduleXpAwarded: 0,
          totalXp: 20,
          level: 1,
          xpIntoLevel: 20,
          xpForNextLevel: 50,
        ));
    final controller = buildController(remoteDataSource: mockRemoteDataSource);

    await controller.advance();

    verify(() => mockRemoteDataSource.completeLesson('test_lesson')).called(1);
    expect(controller.xpSynced, isTrue);
  });
}
