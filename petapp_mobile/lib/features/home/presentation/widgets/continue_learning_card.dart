import 'package:flutter/material.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/game_button.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';
import 'package:petrimonium/features/academy/domain/entities/lesson.dart';
import 'package:petrimonium/features/academy/domain/services/academy_catalog.dart';

/// Home's primary CTA — the single most important thing on the screen
/// (`docs/PRODUCT_VISION.md` §8: "what am I learning" and "what should I do
/// next" both answered by the real next lesson, `AcademyController
/// .nextLesson`). No separate "daily mission" entity is fabricated — this
/// card frames that same real lesson as today's educational objective,
/// since the product has no daily-cadence mission system built yet
/// (`docs/ACADEMY_ENGINE.md`).
class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({
    super.key,
    required this.nextLesson,
    required this.onStartLesson,
    required this.onOpenAcademy,
  });

  /// `null` once every available lesson has been completed.
  final Lesson? nextLesson;

  final VoidCallback onStartLesson;
  final VoidCallback onOpenAcademy;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final lesson = nextLesson;

    if (lesson == null) {
      return GlassCard(
        borderColor: AppColors.goldenBorder.withValues(alpha: 0.55),
        borderWidth: 1.5,
        borderRadius: 20,
        boxShadow: [
          BoxShadow(color: AppColors.goldenBorder.withValues(alpha: 0.16), blurRadius: 24, spreadRadius: 1),
        ],
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.goldenBorder, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      Translator.translate(AppStrings.homeAllLessonsCompleteTitle),
                      style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                Translator.translate(AppStrings.homeAllLessonsCompleteBody),
                style: TextStyle(color: tokens.textSecondary, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 14),
              GameButton(
                label: Translator.translate(AppStrings.homeExploreAcademyCta),
                icon: Icons.school_outlined,
                colors: const [AppColors.neonViolet, AppColors.neonPink],
                onPressed: onOpenAcademy,
              ),
            ],
          ),
        ),
      );
    }

    final moduleTitle = AcademyCatalog.moduleById(lesson.moduleId)?.title;

    // Home's Level-1 primary action (`docs/PRODUCT_VISION.md` §8) gets a
    // static, low-key glow the other Home cards don't — just enough for it
    // to read as "the one thing to do here" without competing with the
    // pet's own ambient aura below it.
    return GlassCard(
      borderColor: AppColors.goldenBorder.withValues(alpha: 0.55),
      borderWidth: 1.5,
      borderRadius: 20,
      boxShadow: [
        BoxShadow(color: AppColors.goldenBorder.withValues(alpha: 0.16), blurRadius: 24, spreadRadius: 1),
      ],
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flag_circle, color: AppColors.goldenBorder, size: 16),
                const SizedBox(width: 6),
                Text(
                  Translator.translate(AppStrings.homeContinueLearningEyebrow).toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.goldenBorder,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (moduleTitle != null) ...[
              Text(
                moduleTitle,
                style: TextStyle(color: tokens.textTertiary, fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
            ],
            Text(
              lesson.title,
              style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 19),
            ),
            const SizedBox(height: 4),
            Text(
              Translator.translate(AppStrings.academyXpToCompleteLabel, params: {'xp': '${lesson.xpReward}'}),
              style: TextStyle(color: tokens.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 16),
            GameButton(
              label: Translator.translate(AppStrings.homeContinueLearningCta),
              icon: Icons.play_arrow_rounded,
              colors: const [AppColors.neonViolet, AppColors.neonPink],
              pulse: true,
              onPressed: onStartLesson,
            ),
          ],
        ),
      ),
    );
  }
}
