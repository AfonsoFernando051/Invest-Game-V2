import 'package:flutter/foundation.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';

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

  Lesson? get nextLesson => AcademyProgressCalculator.nextLessonToContinue(completedIds: completedLessonIds);

  int get totalXpEarned => AcademyCatalog.xpEarnedFor(completedLessonIds);

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

  int completedLessonCountFor(AcademyModule module) {
    return module.lessonIds.where(completedLessonIds.contains).length;
  }
}
