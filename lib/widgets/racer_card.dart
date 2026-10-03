import 'package:flutter/material.dart';

import '../data/character_extras.dart';
import '../models/character.dart';
import '../theme/theme.dart';
import 'racer_widgets.dart';
import 'unlock_status_icon.dart';

/// Driver card for the Character Guide: racer picture with a race-number
/// plate on the left; name, class, tagline and three mini stat gauges on the
/// right; a stripe in the racer's color along the bottom.
class RacerCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const RacerCard({super.key, required this.character, required this.onTap});

  static const double _height = 148;
  static const double _imageWidth = 124;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final extras = CharacterExtras.of(character.id);
    final locked = !character.unlocked;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: _height,
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: _imageWidth,
                    height: _height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        RacerImage(
                          imageAsset: character.imageAsset,
                          color: character.avatarColor,
                          initials: character.initials,
                          width: _imageWidth,
                          height: _height,
                        ),
                        // Fade the picture into the card.
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                AppColors.surface.withValues(alpha: 0.9),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                        if (locked)
                          Container(
                            color: Colors.black.withValues(alpha: 0.45),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.lock_rounded,
                              color: Colors.white70,
                              size: 28,
                            ),
                          ),
                        Positioned(
                          left: 8,
                          bottom: 10,
                          child: RacerNumberBadge(
                            number: extras.racerNumber,
                            color: character.avatarColor,
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.sm + 4,
                        AppSpacing.sm + 4,
                        AppSpacing.sm + 4,
                        AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  character.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              UnlockStatusIcon(unlocked: character.unlocked),
                            ],
                          ),
                          const SizedBox(height: 4),
                          RacerPill(
                            label: character.characterClass.label,
                            color: character.avatarColor,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            extras.tagline,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: _MiniStat(
                                  label: 'SPD',
                                  value: character.speed,
                                  color: character.avatarColor,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _MiniStat(
                                  label: 'ACC',
                                  value: character.acceleration,
                                  color: character.avatarColor,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _MiniStat(
                                  label: 'HDL',
                                  value: character.handling,
                                  color: character.avatarColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: 3, color: character.avatarColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textTertiary,
            fontSize: 9,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0).toDouble(),
            minHeight: 5,
            backgroundColor: AppColors.surfaceHigh,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
