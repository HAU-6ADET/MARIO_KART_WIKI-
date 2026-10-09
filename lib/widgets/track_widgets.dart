import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Vertical timeline for the lap-by-lap plan (lap 1, 2, 3).
class LapPlanTimeline extends StatelessWidget {
  final List<String> steps;
  final Color color;

  const LapPlanTimeline({super.key, required this.steps, required this.color});

  static const _titles = [
    'Lap 1 · Settle in',
    'Lap 2 · Build speed',
    'Lap 3 · Final push',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 13),
                  padding: EdgeInsets.only(
                    left: 26,
                    bottom: i == steps.length - 1 ? 8 : AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 2,
                        color: i == steps.length - 1
                            ? Colors.transparent
                            : color.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        i < _titles.length ? _titles[i] : 'Lap ${i + 1}',
                        style: textTheme.titleMedium?.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(steps[i], style: textTheme.bodyMedium),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    child: Text(
                      '${i + 1}',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The four courses of a cup, with the current one highlighted.
class CupLineup extends StatelessWidget {
  final String cup;
  final List<String> courses;
  final int currentIndex; // 0-based
  final Color color;

  const CupLineup({
    super.key,
    required this.cup,
    required this.courses,
    required this.currentIndex,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 18,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 6),
              Text(cup, style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < courses.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == currentIndex ? color : AppColors.surfaceHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: textTheme.labelSmall?.copyWith(
                        color: i == currentIndex
                            ? Colors.black87
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md - 4),
                  Expanded(
                    child: Text(
                      courses[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: i == currentIndex
                          ? textTheme.titleMedium?.copyWith(fontSize: 15)
                          : textTheme.bodyMedium,
                    ),
                  ),
                  if (i == currentIndex)
                    Icon(Icons.flag_rounded, size: 18, color: color),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Sector-by-sector breakdown; the numbers match the markers on the map.
class SectorGuide extends StatelessWidget {
  final List<String> sectors;
  final Color color;

  const SectorGuide({super.key, required this.sectors, required this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (var i = 0; i < sectors.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == sectors.length - 1 ? 0 : AppSpacing.md - 2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md - 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sector ${i + 1}',
                          style: textTheme.titleMedium?.copyWith(fontSize: 15),
                        ),
                        Text(sectors[i], style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// One tip each for beginner, intermediate and expert drivers.
class SkillTips extends StatelessWidget {
  final List<String> tips;

  const SkillTips({super.key, required this.tips});

  static const _levels = ['Beginner', 'Intermediate', 'Expert'];
  static const _colors = [
    AppColors.success,
    AppColors.secondary,
    AppColors.primary,
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          for (var i = 0; i < tips.length && i < _levels.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == tips.length - 1 ? 0 : AppSpacing.md - 2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(Icons.flag_rounded, size: 18, color: _colors[i]),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _levels[i],
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            color: _colors[i],
                          ),
                        ),
                        Text(tips[i], style: textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
