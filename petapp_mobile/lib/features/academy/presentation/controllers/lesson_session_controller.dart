import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:petrimonium/core/events/app_event.dart';
import 'package:petrimonium/core/events/app_event_bus.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/models/academy_catalog_snapshot.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson_step.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';
import 'package:petrimonium/features/pet/domain/enums/pet_animation_state.dart';
import 'package:petrimonium/features/pet/presentation/mascot/controllers/mascot_controller.dart';

/// How many recent wrong answers in one school trigger the pet's
/// difficulty-detected nudge (see `AcademyProgressLocalRepository.recordMiss`
/// and `PetMessageCatalog.difficultyDetected`) — matches the brief's own
/// example ("you've missed two questions on this topic").
const int kDifficultyDetectionThreshold = 2;

/// Drives a single lesson play-through: current step, the learner's answer
/// (if the step is a question), and completion. Self-owned by `LessonScreen`
/// — mirrors how `MentorChatController` is created and disposed by its own
/// screen rather than shared across tabs, since a lesson session has no
/// reason to outlive the screen that plays it.
///
/// A wrong answer is never penalized: [selectOption] just records the
/// choice so [currentStepIsCorrect] can drive encouraging feedback copy —
/// there is no life/heart to lose and nothing blocks [advance].
class LessonSessionController extends ChangeNotifier {
  LessonSessionController({
    required this.lesson,
    required this.catalog,
    required AcademyProgressLocalRepository academyRepository,
    required MascotController mascotController,
    AcademyRemoteDataSource? academyRemoteDataSource,
  })  : _academyRepository = academyRepository,
        _mascotController = mascotController,
        _academyRemoteDataSource = academyRemoteDataSource;

  final Lesson lesson;

  /// The curriculum snapshot this lesson was opened from — used to resolve
  /// [lesson]'s parent module/school (see [_recordMiss]/[_completeLesson]).
  final AcademyCatalogSnapshot catalog;
  final AcademyProgressLocalRepository _academyRepository;
  final MascotController _mascotController;
  final AcademyRemoteDataSource? _academyRemoteDataSource;

  int currentStepIndex = 0;
  int? selectedOptionIndex;
  bool hasAnswered = false;
  bool isCompleting = false;
  bool isComplete = false;

  /// Whether every question step in this session was answered correctly on
  /// the first try — feeds `AcademyProgressLocalRepository.markLessonPerfect`
  /// (see `MasteryCalculator`). Flipped by the same wrong-answer branch that
  /// already powers the pet's difficulty-detected nudge, so no new detection
  /// logic is needed.
  bool _hadAnyMiss = false;

  /// Whether the real XP/level shown elsewhere in the app has been updated
  /// to reflect this completion yet — false if the backend sync failed
  /// (offline), so nothing here shows a fabricated number.
  bool xpSynced = false;

  LessonStep get currentStep => lesson.steps[currentStepIndex];
  int get totalSteps => lesson.steps.length;
  double get progress => (currentStepIndex + 1) / totalSteps;
  bool get isLastStep => currentStepIndex == totalSteps - 1;

  /// A non-question step can always advance; a question step needs an
  /// answer first — never a hard gate, just "pick one to continue."
  bool get canAdvance => currentStep is! ChoiceQuestionStep || hasAnswered;

  bool get selectedAnswerIsCorrect {
    final step = currentStep;
    if (step is ChoiceQuestionStep && selectedOptionIndex != null) {
      return selectedOptionIndex == step.correctIndex;
    }
    return true;
  }

  void selectOption(int index) {
    if (hasAnswered) return;
    selectedOptionIndex = index;
    hasAnswered = true;
    final step = currentStep;
    if (step is ChoiceQuestionStep && index != step.correctIndex) {
      _hadAnyMiss = true;
      unawaited(_recordMiss());
    }
    notifyListeners();
  }

  Future<void> _recordMiss() async {
    final module = catalog.moduleById(lesson.moduleId);
    if (module == null) return;
    final school = catalog.schoolById(module.schoolId);
    if (school == null) return;
    final count = await _academyRepository.recordMiss(module.schoolId);
    // Exact match, not `>=`: fires once per struggle streak — the counter
    // only returns to a value below the threshold via `resetMisses` on the
    // next lesson completed in this school, so this can't spam on every
    // subsequent miss within the same streak.
    if (count == kDifficultyDetectionThreshold) {
      AppEventBus.instance.emit(DifficultyDetectedEvent(school.title));
    }
  }

  Future<void> advance() async {
    if (isCompleting || isComplete || !canAdvance) return;

    if (isLastStep) {
      await _completeLesson();
      return;
    }

    currentStepIndex++;
    selectedOptionIndex = null;
    hasAnswered = false;
    notifyListeners();
  }

  Future<void> _completeLesson() async {
    isCompleting = true;
    notifyListeners();

    final module = catalog.moduleById(lesson.moduleId);
    final school = module == null ? null : catalog.schoolById(module.schoolId);
    final wasSchoolAlreadyComplete = school == null
        ? true
        : AcademyProgressCalculator.schoolStatus(
              catalog: catalog,
              school: school,
              completedIds: await _academyRepository.loadCompletedLessonIds(),
            ) ==
            SchoolStatus.completed;

    await _academyRepository.markLessonCompleted(lesson.id);
    // Recorded before the sync attempt below — if it fails or the app is killed mid-request,
    // AcademyController.load()'s reconciliation still knows to retry it later.
    await _academyRepository.markPendingSync(lesson.id);
    if (!_hadAnyMiss) await _academyRepository.markLessonPerfect(lesson.id);
    if (module != null) await _academyRepository.resetMisses(module.schoolId);
    _mascotController.triggerEventAnimation(PetAnimationState.victory, duration: const Duration(seconds: 4));
    AppEventBus.instance.emit(LessonCompletedEvent(lesson.id));

    if (school != null && !wasSchoolAlreadyComplete) {
      final nowComplete = AcademyProgressCalculator.schoolStatus(
            catalog: catalog,
            school: school,
            completedIds: await _academyRepository.loadCompletedLessonIds(),
          ) ==
          SchoolStatus.completed;
      if (nowComplete) AppEventBus.instance.emit(SchoolMasteredEvent(school.title));
    }

    isCompleting = false;
    isComplete = true;
    notifyListeners();

    // The backend is the only source of truth for XP/level (see
    // `MascotController.evaluateEvolution`'s doc comment — it overwrites the
    // pet's stored XP outright, so it must never be fed a locally-guessed
    // number). Awaited (not fire-and-forget) so the mascot only updates with
    // a real value; offline/failure just leaves `xpSynced` false — the
    // lesson still completes locally, and the next successful
    // gamification-summary fetch reconciles it.
    await _syncCompletionToBackend();
  }

  Future<void> _syncCompletionToBackend() async {
    final remote = _academyRemoteDataSource;
    if (remote == null) return;
    try {
      final result = await remote.completeLesson(lesson.id);
      await _academyRepository.clearPendingSync(lesson.id);
      await _mascotController.evaluateEvolution(_mascotController.profile.netWorth, result.totalXp);
      xpSynced = true;
      notifyListeners();
    } catch (_) {
      // Offline or backend unavailable — stays in the pending-sync set (see
      // markPendingSync above), so `AcademyController.load()` retries it on the next launch
      // or reconciliation.
    }
  }
}
