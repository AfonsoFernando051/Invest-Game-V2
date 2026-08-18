import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/features/academy/data/datasources/academy_remote_datasource.dart';
import 'package:petrimonium/features/academy/data/models/academy_catalog_snapshot.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_catalog_repository.dart';
import 'package:petrimonium/features/academy/data/repositories/academy_progress_local_repository.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_domain.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/knowledge_level.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_recommendation.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/entities/mastery_tier.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';
import 'package:petrimonium/features/academy/domain/services/academy_recommendation_service.dart';
import 'package:petrimonium/features/academy/domain/services/knowledge_progress_calculator.dart';
import 'package:petrimonium/features/academy/domain/services/mastery_calculator.dart';

/// Owns the Academy module list / overview state: loads persisted progress
/// and the curriculum catalog (from the backend, see
/// `AcademyCatalogRepository`), and exposes derived status per
/// module/lesson. Mirrors `PortfolioController` in shape (a `ChangeNotifier`
/// wrapping repositories + pure domain services).
class AcademyController extends ChangeNotifier {
  AcademyController({
    required AcademyProgressLocalRepository repository,
    required AcademyCatalogRepository catalogRepository,
    AcademyRemoteDataSource? remoteDataSource,
  })  : _repository = repository,
        _catalogRepository = catalogRepository,
        _remoteDataSource = remoteDataSource {
    Translator.languageNotifier.addListener(_onLanguageChanged);
  }

  final AcademyProgressLocalRepository _repository;
  final AcademyCatalogRepository _catalogRepository;
  final AcademyRemoteDataSource? _remoteDataSource;

  bool isLoading = true;

  /// Whether the catalog (see [snapshot]) is being fetched — separate from
  /// [isLoading] (progress) since the two load independently and a screen
  /// needs both ready before it can render curriculum content.
  bool isCatalogLoading = true;

  /// Set only when the catalog has never been fetched successfully *and*
  /// there's no cache to fall back on (e.g. first-ever launch, offline) —
  /// screens should show a retry state rather than an empty catalog. `null`
  /// whenever a cached or freshly-fetched snapshot is available.
  String? catalogError;

  Set<String> completedLessonIds = {};

  /// Lessons completed with every question right on the first try — see
  /// `MasteryCalculator`.
  Set<String> perfectLessonIds = {};

  AcademyCatalogSnapshot? _catalog;

  /// The curriculum for the current language, once loaded — `null` before
  /// the first successful cache read or fetch.
  AcademyCatalogSnapshot? get snapshot => _catalog;

  List<AcademyModule> get modules => _catalog?.modules ?? const [];

  List<School> get schools => _catalog?.schools ?? const [];

  List<AcademyDomain> get domains => _catalog?.domains ?? const [];

  Lesson? get nextLesson {
    final catalog = _catalog;
    if (catalog == null) return null;
    return AcademyProgressCalculator.nextLessonToContinue(catalog: catalog, completedIds: completedLessonIds);
  }

  int get totalXpEarned => _catalog?.xpEarnedFor(completedLessonIds) ?? 0;

  /// Curriculum-completion tier, distinct from the XP-driven Game Level —
  /// see `KnowledgeProgressCalculator`'s doc comment.
  KnowledgeLevel get knowledgeLevel {
    final catalog = _catalog;
    if (catalog == null) return KnowledgeLevel.absoluteBeginner;
    return KnowledgeProgressCalculator.levelForCompletion(
      KnowledgeProgressCalculator.overallCompletionPercent(catalog, completedLessonIds),
    );
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    completedLessonIds = await _repository.loadCompletedLessonIds();
    perfectLessonIds = await _repository.loadPerfectLessonIds();

    isLoading = false;
    notifyListeners();

    await _loadCatalog();

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

  /// Cache-first, fetch-in-background for the current language: renders
  /// instantly from the last-known snapshot (if any) while a fresh one is
  /// fetched over the network, matching `PortfolioController
  /// ._recomputeChart`'s stale-while-revalidate shape. [catalogError] is
  /// only set when neither a cache nor a fresh fetch produced anything.
  Future<void> _loadCatalog() async {
    final lang = Translator.currentLanguage;
    isCatalogLoading = true;
    notifyListeners();

    final cached = await _catalogRepository.loadCached(lang);
    if (cached != null) {
      _catalog = cached;
      notifyListeners();
    }

    try {
      _catalog = await _catalogRepository.fetchAndCache(lang);
      catalogError = null;
    } catch (_) {
      if (cached == null) catalogError = 'offline_no_cache';
    }

    isCatalogLoading = false;
    notifyListeners();
  }

  /// Re-loads the catalog for the newly-selected language — curriculum text
  /// is fetched per language (unlike the old hardcoded catalog, switching
  /// language is no longer free/instant; see `docs/DECISIONS.md`).
  void _onLanguageChanged() {
    unawaited(_loadCatalog());
  }

  @override
  void dispose() {
    Translator.languageNotifier.removeListener(_onLanguageChanged);
    super.dispose();
  }

  ModuleStatus statusFor(AcademyModule module) {
    return AcademyProgressCalculator.moduleStatus(module: module, completedIds: completedLessonIds);
  }

  SchoolStatus schoolStatusFor(School school) {
    final catalog = _catalog;
    if (catalog == null) return SchoolStatus.comingSoon;
    return AcademyProgressCalculator.schoolStatus(catalog: catalog, school: school, completedIds: completedLessonIds);
  }

  List<AcademyModule> modulesForSchool(School school) => _catalog?.modulesForSchool(school.id) ?? const [];

  SchoolStatus domainStatusFor(AcademyDomain domain) {
    final catalog = _catalog;
    if (catalog == null) return SchoolStatus.comingSoon;
    return AcademyProgressCalculator.domainStatus(catalog: catalog, domain: domain, completedIds: completedLessonIds);
  }

  List<School> schoolsForDomain(AcademyDomain domain) {
    final catalog = _catalog;
    if (catalog == null) return const [];
    return domain.schoolIds.map(catalog.schoolById).whereType<School>().toList();
  }

  double domainMasteryFor(AcademyDomain domain) {
    final catalog = _catalog;
    if (catalog == null) return 0.0;
    return KnowledgeProgressCalculator.percentForDomain(catalog, domain, completedLessonIds);
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
    final catalog = _catalog;
    if (catalog == null) return 0.0;
    return KnowledgeProgressCalculator.percentForSchool(catalog, school.id, completedLessonIds);
  }

  /// Real, performance-based Mastery per school — distinct from
  /// [masteryFor]'s completion percent. See `MasteryCalculator`.
  double realMasteryFor(School school) {
    final catalog = _catalog;
    if (catalog == null) return 0.0;
    return MasteryCalculator.percentForSchool(
      catalog: catalog,
      schoolId: school.id,
      completedIds: completedLessonIds,
      perfectIds: perfectLessonIds,
    );
  }

  MasteryTier masteryTierFor(School school) => MasteryCalculator.tierForPercent(realMasteryFor(school));

  /// "What should I do next" — continue, and (when relevant) review a
  /// weak concept. See `AcademyRecommendationService`.
  List<AcademyRecommendation> get recommendations {
    final catalog = _catalog;
    if (catalog == null) return const [];
    return AcademyRecommendationService.recommendationsFor(
      catalog: catalog,
      completedIds: completedLessonIds,
      perfectIds: perfectLessonIds,
    );
  }

  /// Completed lessons not yet answered perfectly, in curriculum order.
  List<Lesson> get reviewQueue {
    final catalog = _catalog;
    if (catalog == null) return const [];
    return AcademyRecommendationService.reviewQueue(
      catalog: catalog,
      completedIds: completedLessonIds,
      perfectIds: perfectLessonIds,
    );
  }

  int get reviewEstimatedMinutes {
    final catalog = _catalog;
    if (catalog == null) return 0;
    return AcademyRecommendationService.reviewEstimatedMinutes(
      catalog: catalog,
      completedIds: completedLessonIds,
      perfectIds: perfectLessonIds,
    );
  }
}
