import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petrimonium/core/constants/app_colors.dart';
import 'package:petrimonium/core/constants/app_strings.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/core/utils/translator.dart';
import 'package:petrimonium/core/widgets/glass_card.dart';
import 'package:petrimonium/features/academy/domain/entities/academy_module.dart';
import 'package:petrimonium/features/academy/domain/services/academy_progress_calculator.dart';

/// Home's "how is my knowledge developing" glance
/// (`docs/PRODUCT_VISION.md` §8): a compact, tappable row of module status
/// chips — real derived data (`AcademyController.modules`/`.statusFor`,
/// the same `AcademyProgressCalculator` the full Academy screen uses), just
/// condensed instead of duplicating `AcademyHomeScreen`'s full module list.
class KnowledgeMapStrip extends StatelessWidget {
  const KnowledgeMapStrip({
    super.key,
    required this.modules,
    required this.statusFor,
    required this.completedLessonCountFor,
    required this.onTapModule,
    required this.onViewAll,
  });

  final List<AcademyModule> modules;
  final ModuleStatus Function(AcademyModule module) statusFor;
  final int Function(AcademyModule module) completedLessonCountFor;
  final void Function(AcademyModule module) onTapModule;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final sorted = [...modules]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Translator.translate(AppStrings.homeKnowledgeMapLabel),
              style: TextStyle(color: tokens.primary.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Text(
                Translator.translate(AppStrings.homeViewFullAcademyCta),
                style: const TextStyle(color: AppColors.neonCyan, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sorted.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => _ModuleChip(
              module: sorted[i],
              status: statusFor(sorted[i]),
              completedLessons: completedLessonCountFor(sorted[i]),
              onTap: () {
                HapticFeedback.selectionClick();
                onTapModule(sorted[i]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ModuleChip extends StatelessWidget {
  const _ModuleChip({
    required this.module,
    required this.status,
    required this.completedLessons,
    required this.onTap,
  });

  final AcademyModule module;
  final ModuleStatus status;
  final int completedLessons;
  final VoidCallback onTap;

  Color get _accent => switch (status) {
        ModuleStatus.completed => AppColors.goldenBorder,
        ModuleStatus.inProgress => AppColors.neonViolet,
        ModuleStatus.available => AppColors.neonCyan,
        ModuleStatus.locked => Colors.transparent,
        ModuleStatus.comingSoon => Colors.transparent,
      };

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    final locked = status == ModuleStatus.comingSoon || status == ModuleStatus.locked;

    return SizedBox(
      width: 84,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: GlassCard(
            surface: locked ? CardSurface.disabled : CardSurface.standard,
            borderColor: locked ? tokens.border : _accent.withValues(alpha: 0.5),
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Opacity(
              opacity: locked ? 0.5 : 1.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(module.icon, color: locked ? tokens.textTertiary : _accent, size: 22),
                      if (status == ModuleStatus.completed)
                        const Positioned(
                          right: -2,
                          top: -2,
                          child: Icon(Icons.check_circle, color: AppColors.goldenBorder, size: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    module.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: tokens.textPrimary, fontSize: 9.5, fontWeight: FontWeight.w600, height: 1.2),
                  ),
                  if (status == ModuleStatus.inProgress) ...[
                    const SizedBox(height: 2),
                    Text(
                      '$completedLessons/${module.lessonIds.length}',
                      style: TextStyle(color: _accent, fontSize: 9, fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
