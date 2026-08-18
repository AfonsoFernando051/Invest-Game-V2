import 'package:flutter/material.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/game_button.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';

/// "Today's Review" (`docs/ACADEMY_ENGINE.md` §3d, brief §25) — a compact
/// nudge to revisit the lessons in `AcademyController.reviewQueue`
/// (completed but not answered perfectly). Only rendered by the caller when
/// that queue is non-empty — an "all caught up" state isn't worth a card,
/// same convention as `AcademyMasterySection`'s `masterySchools.isNotEmpty`
/// gate. Starting a review replays the single oldest due lesson via the
/// existing `LessonScreen` — no new multi-lesson session type, no XP is
/// re-granted (the backend is the only source of truth for XP; see
/// `LessonSessionController`).
class AcademyReviewCard extends StatelessWidget {
  const AcademyReviewCard({super.key, required this.lessonCount, required this.estimatedMinutes, required this.onStart});

  final int lessonCount;
  final int estimatedMinutes;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;

    return GlassCard(
      borderColor: AppColors.neonBlue.withValues(alpha: 0.35),
      borderRadius: 20,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.refresh_rounded, color: AppColors.neonBlue, size: 18),
                const SizedBox(width: 8),
                Text(
                  Translator.translate(AppStrings.academyReviewCardTitle),
                  style: TextStyle(color: tokens.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              Translator.translate(
                AppStrings.academyReviewCardSubtitle,
                params: {'count': '$lessonCount', 'minutes': '$estimatedMinutes'},
              ),
              style: TextStyle(color: tokens.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 14),
            GameButton(
              label: Translator.translate(AppStrings.academyReviewStartButton),
              icon: Icons.refresh_rounded,
              colors: const [AppColors.neonBlue, AppColors.neonCyan],
              onPressed: onStart,
            ),
          ],
        ),
      ),
    );
  }
}
