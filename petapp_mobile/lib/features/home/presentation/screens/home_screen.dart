import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petrimonium/core/di/dependency_injection.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/widgets/app_loading_indicator.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_recommendation.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';
import 'package:petrimonium/features/academy/presentation/controllers/academy_controller.dart';
import 'package:petrimonium/features/academy/presentation/screens/lesson_screen.dart';
import 'package:petrimonium/features/academy/presentation/screens/module_detail_screen.dart';
import 'package:petrimonium/features/academy/presentation/widgets/recommended_for_you_section.dart';
import 'package:petrimonium/features/home/presentation/widgets/continue_learning_card.dart';
import 'package:petrimonium/features/home/presentation/widgets/knowledge_map_strip.dart';
import 'package:petrimonium/features/home/presentation/widgets/learning_hero_card.dart';
import 'package:petrimonium/features/home/presentation/widgets/portfolio_bridge_card.dart';
import 'package:petrimonium/features/home/presentation/widgets/portfolio_not_connected_card.dart';
import 'package:petrimonium/features/home/presentation/widgets/portfolio_reminder_banner.dart';
import 'package:petrimonium/features/pet/presentation/mascot/controllers/mascot_controller.dart';
import 'package:petrimonium/features/portfolio/presentation/controllers/portfolio_controller.dart';
import 'package:petrimonium/features/portfolio/presentation/widgets/shared/error_banner.dart';

/// Home — the app's learning-first orchestration layer
/// (`docs/PRODUCT_VISION.md` §8): where the user is in their learning
/// journey, what to learn next, XP progress, knowledge development, and a
/// compact bridge into their real portfolio. Detailed financial metrics
/// (charts, allocation, holdings, missions/achievements) live on the
/// Portfolio tab, not here.
///
/// No own `Scaffold`/`AppBar`/background — embedded directly in
/// `DashboardScreen`'s shared chrome, mirroring `AcademyHomeScreen` and
/// `PortfolioScreen`.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.portfolioController,
    required this.mascotController,
    required this.onOpenAcademyTab,
    required this.onOpenPortfolioTab,
    required this.showPortfolioReminder,
    required this.onDismissPortfolioReminder,
    required this.investorProfileUnanswered,
  });

  final PortfolioController portfolioController;
  final MascotController mascotController;
  final VoidCallback onOpenAcademyTab;
  final VoidCallback onOpenPortfolioTab;
  final bool showPortfolioReminder;
  final VoidCallback onDismissPortfolioReminder;
  final bool investorProfileUnanswered;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AcademyController _academyController;

  @override
  void initState() {
    super.initState();
    _academyController = AcademyController(
      repository: DI.academyProgressRepository,
      catalogRepository: DI.academyCatalogRepository,
      remoteDataSource: DI.academyRemoteDataSource,
    );
    _academyController.addListener(_onAcademyChanged);
    _academyController.load();
  }

  void _onAcademyChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _academyController.removeListener(_onAcademyChanged);
    _academyController.dispose();
    super.dispose();
  }

  Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.04), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  Future<void> _startLesson(Lesson lesson) async {
    HapticFeedback.selectionClick();
    await Navigator.of(context).push(
      _fadeRoute(LessonScreen(lesson: lesson, catalog: _academyController.snapshot!, mascotController: widget.mascotController)),
    );
    _academyController.load();
  }

  Future<void> _openModule(AcademyModule module) async {
    HapticFeedback.selectionClick();
    await Navigator.of(context).push(
      _fadeRoute(ModuleDetailScreen(module: module, mascotController: widget.mascotController)),
    );
    _academyController.load();
  }

  /// Only the `review` recommendation, if any — `continueLearning` is
  /// already this screen's `ContinueLearningCard`, so showing it again here
  /// would be redundant (brief's own "one primary action per screen"
  /// principle).
  List<AcademyRecommendation> get _reviewRecommendations =>
      _academyController.recommendations.where((r) => r.type == RecommendationType.review).toList();

  void _tapModuleChip(AcademyModule module) {
    final status = _academyController.statusFor(module);
    if (status == ModuleStatus.comingSoon || status == ModuleStatus.locked) return;
    _openModule(module);
  }

  @override
  Widget build(BuildContext context) {
    final portfolioController = widget.portfolioController;

    if (portfolioController.isLoading && portfolioController.holdings.isEmpty && portfolioController.error == null) {
      return const AppLoadingIndicator();
    }

    final hasPortfolio = portfolioController.holdings.isNotEmpty;

    return RefreshIndicator(
      color: context.colors.primary,
      backgroundColor: context.colors.surfaceElevated,
      onRefresh: () => Future.wait([portfolioController.refresh(), _academyController.load()]),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (portfolioController.error != null) ...[
              ErrorBanner(onRetry: portfolioController.refresh),
              const SizedBox(height: 12),
            ],

            ContinueLearningCard(
              nextLesson: _academyController.nextLesson,
              moduleTitle: _academyController.nextLesson == null
                  ? null
                  : _academyController.snapshot?.moduleById(_academyController.nextLesson!.moduleId)?.title,
              onStartLesson: () {
                final lesson = _academyController.nextLesson;
                if (lesson != null) _startLesson(lesson);
              },
              onOpenAcademy: widget.onOpenAcademyTab,
            ),
            const SizedBox(height: 16),

            LearningHeroCard(mascotController: widget.mascotController),
            const SizedBox(height: 16),

            if (widget.showPortfolioReminder) ...[
              PortfolioReminderBanner(onDismiss: widget.onDismissPortfolioReminder),
              const SizedBox(height: 16),
            ],

            if (!_academyController.isLoading && !_academyController.isCatalogLoading) ...[
              KnowledgeMapStrip(
                modules: _academyController.modules,
                statusFor: _academyController.statusFor,
                completedLessonCountFor: _academyController.completedLessonCountFor,
                onTapModule: _tapModuleChip,
                onViewAll: widget.onOpenAcademyTab,
              ),
              const SizedBox(height: 16),
            ],

            if (_reviewRecommendations.isNotEmpty) ...[
              RecommendedForYouSection(recommendations: _reviewRecommendations, onTapLesson: _startLesson),
              const SizedBox(height: 16),
            ],

            if (hasPortfolio)
              PortfolioBridgeCard(
                summary: portfolioController.summary,
                completedLessonCount: _academyController.completedLessonIds.length,
                onViewPortfolio: widget.onOpenPortfolioTab,
              )
            else
              PortfolioNotConnectedCard(showInvestorProfileAction: widget.investorProfileUnanswered),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
