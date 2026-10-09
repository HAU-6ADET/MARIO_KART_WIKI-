import 'package:flutter/material.dart';

import '../data/track_extras.dart';
import '../models/track.dart';
import '../theme/theme.dart';
import 'checkered_strip.dart';
import 'cup_badge.dart';
import 'difficulty_flags.dart';
import 'track_map_image.dart';

/// Race-poster style track card: wide 16:9 course image with the cup badge
/// and name overlaid, a checkered strip, then quick race facts.
class RacingTrackCard extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const RacingTrackCard({super.key, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final extras = TrackExtras.of(track.id);
    final difficultyColor = racingDifficultyColor(track.difficulty);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = width * 9 / 16;
                return Stack(
                  children: [
                    TrackMapImage(
                      imageAsset: track.imageAsset,
                      fallbackColor: track.tileColor,
                      width: width,
                      height: height,
                      flagIconSize: 48,
                    ),
                    // Dark fade so the text stays readable on any image.
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.35),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            stops: const [0, 0.45, 1],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.sm + 2,
                      left: AppSpacing.sm + 2,
                      child: CupBadge(
                        cup: track.cup,
                        raceNumber: extras.raceNumber,
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      bottom: AppSpacing.sm + 2,
                      child: Text(
                        track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const CheckeredStrip(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (extras.tagline.isNotEmpty) ...[
                    Text(
                      extras.tagline,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: difficultyColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    extras.overview,
                    style: textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (extras.highlights.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm + 2),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final tag in extras.highlights)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceHigh,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(tag, style: textTheme.labelSmall),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      DifficultyFlags(difficulty: track.difficulty),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        track.difficulty.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: difficultyColor,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.speed_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'CHALLENGE ${extras.challenge}',
                        style: textTheme.labelSmall,
                      ),
                      const SizedBox(width: AppSpacing.md - 4),
                      const Icon(
                        Icons.loop_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text('${extras.laps} laps', style: textTheme.labelSmall),
                      const SizedBox(width: AppSpacing.md),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
