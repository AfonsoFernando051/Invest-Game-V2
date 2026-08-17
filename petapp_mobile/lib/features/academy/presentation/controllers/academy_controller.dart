import 'package:flutter/foundation.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/knowledge_level.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';
import 'package:petrimonium/features/academy/domain/services/knowledge_progress_calculator.dart';

/// Owns the Academy module list / overview state: loads persisted progress
/// and exposes derived status per module/lesson. Mirrors `PortfolioController`
/// in shape (a `ChangeNotifier` wrapping a repository + pure domain services).
class AcademyController extends ChangeNotifier {
  AcademyController({
    required AcademyProgressLocalRepository repository,
    AcademyRemoteDataSource? remoteDataSource,
  })  : _repository = repository,
        _remoteDataSource = remoteDataSource;

  final AcademyProgressLocalRepository _repository;
  final AcademyRemoteDataSource? _remoteDataSource;

  bool isLoading = true;
  Set<String> completedLessonIds = {};

  List<AcademyModule> get modules => AcademyCatalog.modules;

  List<School> get schools => AcademyCatalog.schools;

  Lesson? get nextLesson => AcademyProgressCalculator.nextLessonToContinue(completedIds: completedLessonIds);

  int get totalXpEarned => AcademyCatalog.xpEarnedFor(completedLessonIds);

  /// Curriculum-completion tier, distinct from the XP-driven Game Level —
  /// see `KnowledgeProgressCalculator`'s doc comment.
  KnowledgeLevel get knowledgeLevel => KnowledgeProgressCalculator.levelForCompletion(
        KnowledgeProgressCalculator.overallCompletionPercent(completedLessonIds),
      );

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    completedLessonIds = await _repository.loadCompletedLessonIds();

    isLoading = false;
    notifyListeners();

    // Best-effort reconciliation with the backend (e.g. a lesson completed
    // on another device). Never blocks the initial render, and a failed/
    // offline sync is silently ignored — local progress remains usable.
    final remote = _remoteDataSource;
    if (remote != null) {
      try {
        final serverIds = await remote.getCompletedLessonIds();
        completedLessonIds = await _repository.mergeCompletedLessonIds(serverIds);
        notifyListeners();
      } catch (_) {
        // Offline or backend unavailable — keep local-only progress.
      }
    }
  }

  ModuleStatus statusFor(AcademyModule module) {
    return AcademyProgressCalculator.moduleStatus(module: module, completedIds: completedLessonIds);
  }

  SchoolStatus schoolStatusFor(School school) {
    return AcademyProgressCalculator.schoolStatus(school: school, completedIds: completedLessonIds);
  }

  List<AcademyModule> modulesForSchool(School school) => AcademyCatalog.modulesForSchool(school.id);

  int completedLessonCountFor(AcademyModule module) {
    return module.lessonIds.where(completedLessonIds.contains).length;
  }

  /// "Mastery" per school (the brief's term for competency progress) —
  /// see `KnowledgeProgressCalculator`'s doc comment on why this is modeled
  /// as per-school completion rather than a second taxonomy.
  double masteryFor(School school) {
    return KnowledgeProgressCalculator.percentForSchool(school.id, completedLessonIds);
  }
}
