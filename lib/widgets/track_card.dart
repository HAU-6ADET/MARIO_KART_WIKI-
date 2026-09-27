import 'package:flutter/material.dart';

import '../models/track.dart';
import '../theme/theme.dart';

/// A single track row: colored flag block on the left, name/cup/difficulty
/// on a dark panel to the right.
class TrackCard extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;

  const TrackCard({super.key, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final difficultyColor = AppDifficultyColors.forDifficulty(track.difficulty);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 96,
                constraints: const BoxConstraints(minHeight: 96),
                color: track.tileColor,
                alignment: Alignment.center,
                child: const Icon(Icons.flag_rounded, color: Colors.black87, size: 28),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        track.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.cup,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: difficultyColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          track.difficulty,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
