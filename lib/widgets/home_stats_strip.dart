import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A dashboard-style row of big numbers (racers / courses / karts).
class HomeStatsStrip extends StatelessWidget {
  final List<({int value, String label, IconData icon})> stats;

  const HomeStatsStrip({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md - 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 36, color: AppColors.divider),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(stats[i].icon, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        '${stats[i].value}',
                        style: textTheme.headlineSmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    stats[i].label,
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
