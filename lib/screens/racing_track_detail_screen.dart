import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../data/track_extras.dart';
import '../models/track.dart';
import '../theme/theme.dart';
import '../widgets/checkered_strip.dart';
import '../widgets/cup_badge.dart';
import '../widgets/difficulty_flags.dart';
import '../widgets/track_map_image.dart';

/// Track Detail, styled like a race-day briefing: full-width course image
/// with cup badge, a checkered strip, a row of race facts, then the course
/// overview, shortcuts, hazards and strategy.
class RacingTrackDetailScreen extends StatelessWidget {
  final String trackId;

  const RacingTrackDetailScreen({super.key, required this.trackId});

  @override
  Widget build(BuildContext context) {
    final track = MockData.tracks.firstWhere((t) => t.id == trackId);
    final appState = AppStateScope.of(context);
    final isFavorited = appState.isFavorited(track.id, FavoriteType.track);
    final textTheme = Theme.of(context).textTheme;
    final extras = TrackExtras.of(track.id);

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(
              track: track,
              extras: extras,
              isFavorited: isFavorited,
              onFavorite: () =>
                  appState.toggleFavorite(track.id, FavoriteType.track),
            ),
            const CheckeredStrip(height: 14),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RaceFacts(track: track, extras: extras),
                  const SizedBox(height: AppSpacing.sectionGap),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.sports_score_rounded,
                          color: AppColors.dataBlue,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Course overview',
                                style: textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(extras.overview, style: textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _InfoSection(
                    title: 'Shortcuts',
                    icon: Icons.alt_route_rounded,
                    color: AppColors.success,
                    items: track.shortcuts,
                  ),
                  _InfoSection(
                    title: 'Hazards',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.secondary,
                    items: track.hazards,
                  ),
                  _InfoSection(
                    title: 'Strategy',
                    icon: Icons.speed_rounded,
                    color: AppColors.primary,
                    items: track.strategyTips,
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

class _Hero extends StatelessWidget {
  final Track track;
  final TrackExtras extras;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const _Hero({
    required this.track,
    required this.extras,
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 9 / 16 + MediaQuery.paddingOf(context).top;
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              TrackMapImage(
                imageAsset: track.imageAsset,
                fallbackColor: track.tileColor,
                width: width,
                height: height,
                flagIconSize: 64,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      stops: const [0, 0.4, 1],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorited
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.secondary,
                          size: 28,
                        ),
                        onPressed: onFavorite,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.pad,
                right: AppSpacing.pad,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CupBadge(cup: track.cup, raceNumber: extras.raceNumber),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      track.name,
                      style: textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Four quick facts in a row: difficulty, laps, setting, first appearance.
class _RaceFacts extends StatelessWidget {
  final Track track;
  final TrackExtras extras;

  const _RaceFacts({required this.track, required this.extras});

  @override
  Widget build(BuildContext context) {
    final difficultyColor = racingDifficultyColor(track.difficulty);
    return IntrinsicHeight(
      // Row + stretch needs a bounded height; inside a scroll view it has
      // none, so size the row to its tallest tile instead.
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _FactTile(
            label: 'DIFFICULTY',
            value: track.difficulty,
            valueColor: difficultyColor,
            leading: DifficultyFlags(difficulty: track.difficulty, size: 14),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _FactTile(
            label: 'LAPS',
            value: '${extras.laps}',
            leading: const Icon(
              Icons.loop_rounded,
              size: 16,
              color: AppColors.dataBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _FactTile(
            label: 'SETTING',
            value: extras.setting,
            leading: const Icon(
              Icons.terrain_rounded,
              size: 16,
              color: AppColors.dataBlue,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _FactTile(
            label: 'DEBUT',
            value: extras.origin,
            leading: const Icon(
              Icons.history_rounded,
              size: 16,
              color: AppColors.dataBlue,
            ),
          ),
        ),
      ],
      ),
    );
  }
}

class _FactTile extends StatelessWidget {
  final String label;
  final String value;
  final Widget leading;
  final Color? valueColor;

  const _FactTile({
    required this.label,
    required this.value,
    required this.leading,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md - 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading,
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: valueColor ?? AppColors.onSurface,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              fontSize: 9,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;

  const _InfoSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final item in items)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              // Clip so the colored left stripe follows the rounded corners.
              clipBehavior: Clip.antiAlias,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(width: 4, color: color),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text(
                          item,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
