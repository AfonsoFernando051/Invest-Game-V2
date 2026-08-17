import 'package:flutter/material.dart';
import 'package:petrimonium/core/theme/app_color_tokens.dart';
import 'package:petrimonium/features/academy/domain/entities/school.dart';
import 'package:petrimonium/features/academy/presentation/widgets/academy_progress_bar.dart';

/// One row of the Academy home's "Your Mastery" section — a school's icon,
/// title, and completion percent among its currently-available content
/// (see `AcademyController.masteryFor`). Only shown for schools with real
/// content; a `comingSoon` school has nothing to report yet.
class MasteryBarRow extends StatelessWidget {
  const MasteryBarRow({super.key, required this.school, required this.percent});

  final School school;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final tokens = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(school.icon, size: 16, color: tokens.textSecondary),
          const SizedBox(width: 8),
          SizedBox(
            width: 96,
            child: Text(
              school.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: tokens.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: AcademyProgressBar(progress: percent, height: 6)),
          const SizedBox(width: 10),
          SizedBox(
            width: 34,
            child: Text(
              '${(percent * 100).round()}%',
              textAlign: TextAlign.right,
              style: TextStyle(color: tokens.textTertiary, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
