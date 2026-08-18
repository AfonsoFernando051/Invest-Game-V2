import 'package:flutter/foundation.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_domain.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/knowledge_level.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_recommendation.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/mastery_tier.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_domain_catalog.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';
import 'package:petrimonium/features/academy/domain/services/academy_recommendation_service.dart';
import 'package:petrimonium/features/academy/domain/services/knowledge_progress_calculator.dart';
import 'package:petrimonium/features/academy/domain/services/mastery_calculator.dart';

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

  /// Lessons completed with every question right on the first try — see
  /// `MasteryCalculator`.
  Set<String> perfectLessonIds = {};

  List<AcademyModule> get modules => AcademyCatalog.modules;

  List<School> get schools => AcademyCatalog.schools;

  List<AcademyDomain> get domains => AcademyDomainCatalog.domains;

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
    perfectLessonIds = await _repository.loadPerfectLessonIds();

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

  SchoolStatus domainStatusFor(AcademyDomain domain) {
    return AcademyProgressCalculator.domainStatus(domain: domain, completedIds: completedLessonIds);
  }

  List<School> schoolsForDomain(AcademyDomain domain) {
    return domain.schoolIds.map(AcademyCatalog.schoolById).whereType<School>().toList();
  }

  double domainMasteryFor(AcademyDomain domain) {
    return KnowledgeProgressCalculator.percentForDomain(domain, completedLessonIds);
  }

  int completedLessonCountFor(AcademyModule module) {
    return module.lessonIds.where(completedLessonIds.contains).length;
  }

  /// Progress per school: how much of its curriculum has been completed.
  /// Despite the name (kept for call-site compatibility), this is
  /// completion percent, not performance — see [realMasteryFor] for actual
  /// Mastery, and `MasteryCalculator`'s doc comment for why the two are kept
  /// distinct.
  double masteryFor(School school) {
    return KnowledgeProgressCalculator.percentForSchool(school.id, completedLessonIds);
  }

  /// Real, performance-based Mastery per school — distinct from
  /// [masteryFor]'s completion percent. See `MasteryCalculator`.
  double realMasteryFor(School school) {
    return MasteryCalculator.percentForSchool(
      schoolId: school.id,
      completedIds: completedLessonIds,
      perfectIds: perfectLessonIds,
    );
  }

  MasteryTier masteryTierFor(School school) => MasteryCalculator.tierForPercent(realMasteryFor(school));

  /// "What should I do next" — continue, and (when relevant) review a
  /// weak concept. See `AcademyRecommendationService`.
  List<AcademyRecommendation> get recommendations => AcademyRecommendationService.recommendationsFor(
        completedIds: completedLessonIds,
        perfectIds: perfectLessonIds,
      );

  /// Completed lessons not yet answered perfectly, in curriculum order.
  List<Lesson> get reviewQueue => AcademyRecommendationService.reviewQueue(
        completedIds: completedLessonIds,
        perfectIds: perfectLessonIds,
      );

  int get reviewEstimatedMinutes => AcademyRecommendationService.reviewEstimatedMinutes(
        completedIds: completedLessonIds,
        perfectIds: perfectLessonIds,
      );
}
