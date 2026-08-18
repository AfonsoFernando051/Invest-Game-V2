import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/theme/app_motion.dart';
import 'package:petrimonium/core/theme/app_spacing.dart';
import 'package:petrimonium/core/theme/background_presets.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/cosmic_background.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';
import 'package:petrimonium/features/academy/presentation/screens/financial_lab/compound_interest_lab_screen.dart';

/// Entry point for the Financial Lab (`docs/ACADEMY_ENGINE.md` §3d, brief
/// §27) — simulations that teach concepts by letting the learner change
/// variables and see why the result changes, rather than a static
/// calculator. Only "Compound Interest" is real today; the rest are shown
/// as `contentAvailable: false`-style "coming soon" cards, the exact same
/// pattern already used for not-yet-authored Schools/Modules.
class FinancialLabHomeScreen extends StatelessWidget {
  const FinancialLabHomeScreen({super.key});

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
      transitionDuration: AppMotion.pageTransition,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          Translator.translate(AppStrings.financialLabTitle),
          style: TextStyle(color: tokens.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: tokens.textPrimary),
          onPressed: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
        ),
      ),
      body: CosmicBackground(
        intensity: BackgroundIntensity.subtle,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Translator.translate(AppStrings.financialLabSubtitle),
                  style: TextStyle(color: tokens.textSecondary, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: AppSpacing.xl),
                _LabTile(
                  icon: Icons.trending_up_rounded,
                  title: Translator.translate(AppStrings.compoundInterestLabTitle),
                  subtitle: Translator.translate(AppStrings.compoundInterestLabSubtitle),
                  available: true,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.of(context).push(_fadeRoute(const CompoundInterestLabScreen()));
                  },
                ),
                const SizedBox(height: 12),
                _LabTile(
                  icon: Icons.shopping_basket_outlined,
                  title: Translator.translate(AppStrings.inflationLabTitle),
                  available: false,
                ),
                const SizedBox(height: 12),
                _LabTile(
                  icon: Icons.account_balance_outlined,
                  title: Translator.translate(AppStrings.fixedIncomeLabTitle),
                  available: false,
                ),
                const SizedBox(height: 12),
                _LabTile(
                  icon: Icons.hub_outlined,
                  title: Translator.translate(AppStrings.diversificationLabTitle),
                  available: false,
                ),
                const SizedBox(height: 12),
                _LabTile(
                  icon: Icons.pie_chart_outline_rounded,
                  title: Translator.translate(AppStrings.portfolioLabTitle),
                  available: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabTile extends StatelessWidget {
  const _LabTile({required this.icon, required this.title, this.subtitle, required this.available, this.onTap});

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool available;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final accent = available ? AppColors.neonCyan : tokens.textTertiary;

    return GestureDetector(
      onTap: available ? onTap : null,
      child: Opacity(
        opacity: available ? 1 : 0.55,
        child: GlassCard(
          borderColor: accent.withValues(alpha: available ? 0.3 : 0.12),
          borderRadius: 16,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: accent.withValues(alpha: 0.14), shape: BoxShape.circle),
                  child: Icon(icon, color: accent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle!, style: TextStyle(color: tokens.textTertiary, fontSize: 11)),
                      ],
                    ],
                  ),
                ),
                if (!available)
                  Text(
                    Translator.translate(AppStrings.labComingSoon),
                    style: TextStyle(color: tokens.textTertiary, fontSize: 10, fontWeight: FontWeight.w700),
                  )
                else
                  Icon(Icons.chevron_right, color: tokens.textTertiary, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
