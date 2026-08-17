import 'package:flutter/material.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/theme/app_radii.dart';
import 'package:petrimonium/core/theme/app_spacing.dart';
import 'package:petrimonium/core/theme/app_text_styles.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';
import 'package:petrimonium/features/academy/domain/entities/knowledge_level.dart';
import 'package:petrimonium/features/academy/domain/services/knowledge_progress_calculator.dart';

/// `AcademyHomeScreen`'s top card: Game Level + XP earned, plus Knowledge
/// Progress underneath. Kept deliberately visually distinct from Game Level
/// (no icon circle, secondary color) — Knowledge Progress must never read as
/// the same kind of number (PRODUCT_VISION.md §9).
class AcademyLevelHeader extends StatelessWidget {
  const AcademyLevelHeader({super.key, required this.level, required this.totalXpEarned, required this.knowledgeLevel});

  final int level;
  final int totalXpEarned;
  final KnowledgeLevel knowledgeLevel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    return GlassCard(
      borderColor: AppColors.neonCyan.withValues(alpha: 0.3),
      borderRadius: AppRadii.xl,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonCyan.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.neonCyan.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: const Icon(Icons.school_outlined, color: AppColors.neonCyan, size: 24),
                ),
                const SizedBox(width: AppSpacing.md + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translator.translate(AppStrings.academyLevelLabel, params: {'level': '$level'}),
                        style: AppTextStyles.title.copyWith(color: tokens.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Translator.translate(AppStrings.academyXpEarnedLabel, params: {'xp': '$totalXpEarned'}),
                        style: AppTextStyles.label.copyWith(color: tokens.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md + 2),
            Divider(color: tokens.textPrimary.withValues(alpha: 0.08), height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.psychology_alt_outlined, color: AppColors.goldenBorder, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    Translator.translate(
                      AppStrings.academyKnowledgeLevelLabel,
                      params: {'tier': KnowledgeProgressCalculator.labelFor(knowledgeLevel)},
                    ),
                    style: AppTextStyles.label.copyWith(color: tokens.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
