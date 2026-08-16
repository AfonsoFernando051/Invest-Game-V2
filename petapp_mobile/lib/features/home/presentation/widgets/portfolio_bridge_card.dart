import 'package:flutter/material.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';
import 'package:petrimonium/features/portfolio/domain/entities/portfolio_summary.dart';
import 'package:petrimonium/features/portfolio/presentation/widgets/shared/formatters.dart';

/// Home's compact "apply what you learned" bridge into the real portfolio
/// (`docs/PRODUCT_VISION.md` §8 #5/#6) — a snapshot, not a dashboard. Full
/// financial metrics (charts, allocation, holdings) live on the Portfolio
/// tab; this card only orients and links there.
///
/// No per-concept "you learned P/E, here's how it looks on this asset"
/// callback is fabricated here — that Educational Portfolio Intelligence
/// engine is explicitly not built yet (`docs/FEATURES.md`). The honest,
/// real signal available today is how many lessons have been completed, so
/// that's what this card surfaces.
class PortfolioBridgeCard extends StatelessWidget {
  const PortfolioBridgeCard({
    super.key,
    required this.summary,
    required this.completedLessonCount,
    required this.onViewPortfolio,
  });

  final PortfolioSummary summary;
  final int completedLessonCount;
  final VoidCallback onViewPortfolio;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final gainPositive = summary.totalGainPercent >= 0;

    return GlassCard(
      backgroundColor: tokens.surface.withValues(alpha: context.isDarkMode ? 0.5 : 0.94),
      borderColor: AppColors.neonCyan.withValues(alpha: 0.3),
      borderRadius: 20,
      borderWidth: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Translator.translate(AppStrings.homePortfolioBridgeLabel),
              style: TextStyle(color: tokens.primary.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _stat(
                    context,
                    label: 'Valor Total',
                    value: PortfolioFormatters.compactCurrency(summary.currentValue),
                    color: AppColors.neonCyan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _stat(
                    context,
                    label: 'Resultado',
                    value: '${gainPositive ? '+' : ''}${summary.totalGainPercent.toStringAsFixed(1)}%',
                    color: gainPositive ? tokens.success : tokens.error,
                  ),
                ),
              ],
            ),
            if (completedLessonCount > 0) ...[
              const SizedBox(height: 14),
              Text(
                Translator.translate(
                  AppStrings.homePortfolioBridgeApplyMessage,
                  params: {'count': '$completedLessonCount'},
                ),
                style: TextStyle(color: tokens.textSecondary, fontSize: 12.5, height: 1.4),
              ),
            ],
            const SizedBox(height: 14),
            GestureDetector(
              onTap: onViewPortfolio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    Translator.translate(AppStrings.homeViewPortfolioCta),
                    style: const TextStyle(color: AppColors.neonCyan, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, color: AppColors.neonCyan, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, {required String label, required String value, required Color color}) {
    final tokens = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: tokens.textSecondary, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
