import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The four tappable tiles on Home: Characters, Tracks, Karts & Bikes,
/// Favorites. Styled as race-garage tiles: an accent-tinted gradient, a big
/// faded icon behind the text and an accent stripe along the bottom.
class CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent.withValues(alpha: 0.28), AppColors.surface],
            ),
          ),
          child: Stack(
            children: [
              // Big faded icon behind the text.
              Positioned(
                right: -10,
                bottom: -6,
                child: Icon(
                  icon,
                  size: 84,
                  color: accent.withValues(alpha: 0.12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md + 3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.black87, size: 22),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Accent stripe along the bottom edge.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: 3, color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
