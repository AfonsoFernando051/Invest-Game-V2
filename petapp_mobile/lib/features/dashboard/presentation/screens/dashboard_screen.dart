import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_color_tokens.dart';
import '../../../../core/utils/translator.dart';
import '../../../../core/utils/game_snack.dart';
import '../../../../core/widgets/confirm_logout_dialog.dart';
import '../../../../core/theme/background_presets.dart';
import '../../../../core/widgets/cosmic_background.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/events/app_event.dart';
import '../../../../core/events/app_event_bus.dart';
import '../../../academy/presentation/screens/academy_home_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../game/domain/services/level_calculator.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../pet/presentation/mascot/controllers/mascot_controller.dart';
import '../../../portfolio/domain/entities/achievement.dart';
import '../../../portfolio/presentation/controllers/portfolio_controller.dart';
import '../../../portfolio/presentation/screens/passive_income_screen.dart';
import '../../../portfolio/presentation/screens/portfolio_screen.dart';
import '../../../portfolio/presentation/widgets/achievement_celebration_overlay.dart';
import '../../../portfolio/presentation/widgets/dividend_notifications_sheet.dart';
import '../../../mentor/presentation/screens/mentor_screen.dart';
import '../../../pet/presentation/companion/pet_companion_controller.dart';
import '../../../pet/presentation/companion/pet_context.dart';
import '../../../pet/presentation/companion/widgets/pet_companion_header.dart';
import '../../../pet/presentation/companion/widgets/pet_speech_bubble.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Shared across the Início (Home) and Carteira (Portfolio) tabs so both
  // reflect the same real holdings/summary/allocation data and a single
  // in-flight load — no duplicate fetches, no drift between tabs.
  late final MascotController _mascotController;
  late final PortfolioController _portfolioController;

  // The persistent pet companion's speech-bubble/interaction state — one
  // instance shared by every tab and by `ProfileScreen` (pushed with it),
  // so there is a single message queue/cooldown ledger for the whole
  // authenticated session (see `PetCompanionController` class doc).
  late final PetCompanionController _companionController;

  // Newly-unlocked achievements awaiting their celebration overlay (see
  // `PortfolioController.newlyUnlocked`) — previously these unlocked
  // completely silently, with no on-screen reward moment at all.
  List<Achievement> _celebrating = [];

  // Whether the pet should nudge the user about the (skipped) portfolio
  // step this session, and whether the risk-assessment questionnaire is
  // still unanswered — both feed the "what to do now" placeholder content
  // shown when there's no live portfolio yet.
  bool _showPortfolioReminder = false;
  bool _investorProfileUnanswered = false;

  // First real consumer of `AppEventBus`: reacts to game-progression events
  // (currently just level-ups) without the emitter (`MascotController`)
  // knowing this screen exists.
  StreamSubscription<AppEvent>? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _mascotController = MascotController(repository: DI.mascotRepository);
    _companionController = PetCompanionController(
      mascotController: _mascotController,
      preferencesRepository: DI.petCompanionPreferencesRepository,
    );
    _portfolioController = PortfolioController(
      repository: DI.portfolioRepository,
      achievementsLocalRepository: DI.achievementsLocalRepository,
      achievementsRepository: DI.achievementsRepository,
      gamificationRepository: DI.gamificationRepository,
      mascotController: _mascotController,
    );
    _initCompanionGreeting();
    _portfolioController.addListener(_onPortfolioChanged);
    _portfolioController.loadAll();
    // Loaded here (not just on first Proventos-tab visit) so the
    // notification bell's badge reflects real upcoming payments as soon as
    // the dashboard opens, even if the user never taps into Proventos.
    _portfolioController.loadDividendRadarIfNeeded();
    _loadOnboardingSignals();
    _eventSubscription = AppEventBus.instance.stream.listen(_onAppEvent);
  }

  void _onAppEvent(AppEvent event) {
    if (!mounted) return;
    if (event is UserLeveledUpEvent) {
      GameSnack.showWithHaptic(
        context,
        Translator.translate(
          AppStrings.levelUpAchieved,
          params: {'level': '${event.newLevel}'},
        ),
        isSuccess: true,
      );
    }
  }

  Future<void> _initCompanionGreeting() async {
    await _mascotController.loadProfile();
    if (!mounted) return;
    _companionController.enterContext(PetContext.home);
  }

  Future<void> _loadOnboardingSignals() async {
    final showReminder = await DI.onboardingStateRepository
        .shouldShowPortfolioReminder();
    if (showReminder) {
      // Recorded the moment we decide to show it, not on dismiss — so a
      // user who just navigates away without tapping anything still gets
      // the cooldown, instead of seeing it again next session.
      final sessionCount = await DI.onboardingStateRepository
          .currentSessionCount();
      await DI.onboardingStateRepository.markReminderShown(sessionCount);
    }

    bool investorProfileUnanswered = false;
    try {
      final status = await DI.onboardingRepository.getStatus();
      investorProfileUnanswered = !status.hasAnswered;
    } catch (_) {
      // Non-critical suggestion — if the status check fails, just omit it.
    }
    if (!mounted) return;
    setState(() {
      _showPortfolioReminder = showReminder;
      _investorProfileUnanswered = investorProfileUnanswered;
    });
  }

  void _onPortfolioChanged() {
    setState(() {
      if (_portfolioController.newlyUnlocked.isNotEmpty) {
        _celebrating = _portfolioController.newlyUnlocked;
        _portfolioController.clearNewlyUnlocked();
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _portfolioController.removeListener(_onPortfolioChanged);
    _portfolioController.dispose();
    _companionController.dispose();
    _mascotController.dispose();
    super.dispose();
  }

  // Shared background instance for all tabs (the IndexedStack below keeps
  // every tab's state alive, so there's one CosmicBackground behind all of
  // them, not five). Content-hierarchy comes from swapping `intensity` per
  // selected tab instead: full cosmic expression on Home, progressively
  // quieter as the screen gets more cognitively demanding, down to Academy.
  // Lesson/quiz screens go one step further with their own `focus`-level
  // CosmicBackground pushed as a separate route (see LessonScreen).
  static const List<BackgroundIntensity> _tabIntensities = [
    BackgroundIntensity.immersive, // Home
    BackgroundIntensity.balanced, // Carteira / Portfolio
    BackgroundIntensity.balanced, // Proventos / Passive income
    BackgroundIntensity.subtle, // Academia
    BackgroundIntensity.mentor, // Mentor
  ];

  Widget _buildBackground({required Widget child}) {
    return CosmicBackground(
      intensity: _tabIntensities[_selectedIndex],
      child: child,
    );
  }

  // ── Page route helper ─────────────────────────────────────────────────────
  Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(begin: const Offset(0, 0.04), end: Offset.zero)
                  .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          ),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  // ── Persistent pet companion: route-aware context + destination routing ──
  // (`docs/PROJECT_CONTEXT.md`'s Pet Companion section, `PetContext`'s doc
  // comment on why this mirrors the 5 real tabs + Profile rather than a
  // generic missions/goals set that doesn't exist in this app.)
  PetContext _petContextForTabIndex(int index) => switch (index) {
    0 => PetContext.home,
    1 || 2 =>
      PetContext
          .portfolio, // Carteira / Proventos share the same companion voice
    3 => PetContext.academy,
    _ => PetContext.mentor,
  };

  void _onTabSelected(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = index);
    _companionController.enterContext(
      _petContextForTabIndex(index),
      data: index == 1 || index == 2
          ? {'count': '${_portfolioController.holdings.length}'}
          : const {},
    );
  }

  /// Where "Learn" / "Portfolio" / "Progress" in [PetInteractionSheet], or a
  /// speech-bubble action, actually take the user.
  void _handleCompanionDestination(PetContext destination) {
    switch (destination) {
      case PetContext.academy:
        _onTabSelected(3);
      case PetContext.portfolio:
        _onTabSelected(1);
      case PetContext.mentor:
        _onTabSelected(4);
      case PetContext.home:
        _onTabSelected(0);
      case PetContext.profile:
        _openProfile();
    }
  }

  Future<void> _openProfile() async {
    _companionController.dismiss();
    _companionController.enterContext(PetContext.profile);
    await Navigator.of(context).push(
      _fadeRoute(ProfileScreen(companionController: _companionController)),
    );
    // Settings (reached via Profile) may have renamed the pet —
    // reload so the AppBar/greeting reflect it immediately.
    await _mascotController.loadProfile();
    if (mounted) setState(() {});
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> _confirmLogout() async {
    final confirmed = await ConfirmLogoutDialog.show(context);

    if (confirmed && mounted) {
      HapticFeedback.mediumImpact();
      await DI.authRepository.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(_fadeRoute(const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds the AppBar/bottom-nav chrome (and everything under it) when
    // the user switches language in Settings — matches the same explicit
    // per-screen listening pattern `SettingsScreen` and the Academy screens
    // already use, rather than relying on the top-level `MyApp` rebuild
    // alone (which resets `FutureBuilder`'s start-route resolution and would
    // otherwise flash the splash screen on every language switch).
    return ValueListenableBuilder<String>(
      valueListenable: Translator.languageNotifier,
      builder: (context, _, __) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final tokens = context.colors;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _buildAppBarTitle(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: tokens.textSecondary),
            onPressed: () {},
          ),
          _buildNotificationsButton(),
          IconButton(
            icon: Icon(Icons.settings_outlined, color: tokens.textSecondary),
            tooltip: Translator.translate(AppStrings.profileTooltip),
            onPressed: _openProfile,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.neonPurple),
            tooltip: Translator.translate(AppStrings.logoutTooltip),
            onPressed: _confirmLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(
            child: SafeArea(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildHomeContent(),
                  _buildWalletContent(),
                  _buildPassiveIncomeContent(),
                  _buildAcademyContent(),
                  _buildMentorContent(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.only(top: kToolbarHeight + 6),
                child: PetSpeechBubbleOverlay(
                  controller: _companionController,
                  onActionSelected: (action) =>
                      _handleCompanionDestination(action.destination),
                ),
              ),
            ),
          ),
          if (_celebrating.isNotEmpty)
            AchievementCelebrationOverlay(
              achievements: _celebrating,
              onDismiss: () => setState(() => _celebrating = []),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── AppBar title — compact player HUD, anchored by the persistent pet
  // companion (`docs/PROJECT_CONTEXT.md`'s Pet Companion section) ─────────
  Widget _buildAppBarTitle() {
    // Real level derived from the same accumulated XP that drives pet
    // evolution (`MascotController.profile.xp`), not a hardcoded number.
    final level = LevelCalculator.fromXp(_mascotController.profile.xp).level;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PetCompanionHeader(
          controller: _companionController,
          onDestinationSelected: _handleCompanionDestination,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Invest Game',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              _mascotController.profile.name?.isNotEmpty == true
                  ? Translator.translate(
                      AppStrings.appBarPlayerNamedGreeting,
                      params: {
                        'petName': _mascotController.profile.name!,
                        'level': '$level',
                      },
                    )
                  : Translator.translate(
                      AppStrings.appBarPlayerGenericGreeting,
                      params: {'level': '$level'},
                    ),
              style: TextStyle(
                color: context.colors.primary.withValues(alpha: 0.9),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Notifications: upcoming dividends for the user's real holdings ──────
  // Badge count is real and provider-confirmed (`DividendRadar.upcoming`,
  // the same data `DividendRadarSection` renders on the Proventos tab) —
  // never a placeholder or simulated count.
  Widget _buildNotificationsButton() {
    final upcomingCount = _portfolioController.dividendRadar.upcoming.length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: context.colors.textSecondary,
          ),
          tooltip: Translator.translate(AppStrings.notificationsTooltip),
          onPressed: _openNotifications,
        ),
        if (upcomingCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                decoration: BoxDecoration(
                  color: context.colors.error,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.colors.backgroundSecondary,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  upcomingCount > 9 ? '9+' : '$upcomingCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _openNotifications() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AnimatedBuilder(
        animation: _portfolioController,
        builder: (context, _) => DividendNotificationsSheet(
          isLoading: _portfolioController.isDividendRadarLoading,
          error: _portfolioController.dividendRadarError,
          upcoming: _portfolioController.dividendRadar.upcoming,
          onRetry: _portfolioController.refreshDividendRadar,
        ),
      ),
    );
  }

  // ── Home: learning-first orchestration layer (docs/PRODUCT_VISION.md §8) ─
  // Detailed financial metrics, missions and achievements live on Carteira
  // (Portfolio) now — Home orients the user in their learning journey first.
  // Both tabs share `_portfolioController`/`_mascotController` so they
  // always agree.
  Widget _buildHomeContent() {
    return HomeScreen(
      portfolioController: _portfolioController,
      mascotController: _mascotController,
      onOpenAcademyTab: () => setState(() => _selectedIndex = 3),
      onOpenPortfolioTab: () => setState(() => _selectedIndex = 1),
      showPortfolioReminder: _showPortfolioReminder,
      onDismissPortfolioReminder: () =>
          setState(() => _showPortfolioReminder = false),
      investorProfileUnanswered: _investorProfileUnanswered,
    );
  }

  // ── Wallet / Portfolio ───────────────────────────────────────────────────
  Widget _buildWalletContent() {
    return PortfolioScreen(
      controller: _portfolioController,
      mascotController: _mascotController,
    );
  }

  // ── Proventos / Passive Income ────────────────────────────────────────────
  Widget _buildPassiveIncomeContent() {
    return PassiveIncomeScreen(controller: _portfolioController);
  }

  // ── Academia: module/lesson progression (see docs/ACADEMY_ENGINE.md) ────
  Widget _buildAcademyContent() {
    return AcademyHomeScreen(
      mascotController: _mascotController,
      companionController: _companionController,
    );
  }

  // ── Mentor: AI-powered chat with the pet acting as investment mentor ────
  Widget _buildMentorContent() {
    return const MentorScreen();
  }

  // ── Analytics (hidden from navigation for now — kept for a future tab) ───
  // ignore: unused_element
  Widget _buildAnalyticsContent() {
    final tokens = context.colors;
    return Center(
      child: GlassCard(
        backgroundColor: tokens.surface.withValues(
          alpha: context.isDarkMode ? 0.6 : 0.94,
        ),
        borderColor: AppColors.neonCyan.withValues(alpha: 0.3),
        borderRadius: 24,
        borderWidth: 1,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_graph,
                size: 64,
                color: AppColors.neonCyan.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 16),
              Text(
                'Análise Estratégica',
                style: TextStyle(
                  color: tokens.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Centro de análise de ativos\nem construção, Comandante.',
                textAlign: TextAlign.center,
                style: TextStyle(color: tokens.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final tokens = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: tokens.backgroundSecondary,
        border: Border(
          top: BorderSide(
            color: tokens.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: tokens.primary.withValues(
              alpha: context.isDarkMode ? 0.12 : 0.08,
            ),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: tokens.primary,
        unselectedItemColor: tokens.textTertiary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(
            icon: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.rocket_launch_outlined),
            ),
            activeIcon: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.rocket_launch),
            ),
            label: Translator.translate(AppStrings.navHome),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.diamond_outlined),
            activeIcon: const Icon(Icons.diamond),
            label: Translator.translate(AppStrings.navWallet),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.payments_outlined),
            activeIcon: const Icon(Icons.payments),
            label: Translator.translate(AppStrings.navPassiveIncome),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school_outlined),
            activeIcon: const Icon(Icons.school),
            label: Translator.translate(AppStrings.navAcademy),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_outlined),
            activeIcon: const Icon(Icons.auto_awesome),
            label: Translator.translate(AppStrings.navMentor),
          ),
        ],
      ),
    );
  }
}
