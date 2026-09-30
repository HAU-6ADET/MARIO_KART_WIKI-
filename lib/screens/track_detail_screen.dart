import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/track_map_image.dart';

/// Track Detail, built to the same profile pattern as Character Detail:
/// a gradient hero with a large image, name + subtitle, favorite star,
/// then an info sheet below. Previously this screen used a plain
/// SliverAppBar that didn't match Character Detail's look — see the note
/// that used to live here about mockup.pdf only describing this screen in
/// a caption ("same pattern as Character Detail") with no actual frame.
class TrackDetailScreen extends StatelessWidget {
  final String trackId;

  const TrackDetailScreen({super.key, required this.trackId});

  @override
  Widget build(BuildContext context) {
    final track = MockData.tracks.firstWhere((t) => t.id == trackId);
    final appState = AppStateScope.of(context);
    final isFavorited = appState.isFavorited(track.id, FavoriteType.track);
    final difficultyColor = AppDifficultyColors.forDifficulty(track.difficulty);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pad, AppSpacing.md, AppSpacing.pad, AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [track.tileColor, AppColors.background],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
                            color: AppColors.secondary,
                            size: 26,
                          ),
                          onPressed: () =>
                              appState.toggleFavorite(track.id, FavoriteType.track),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Map/course image — same fallback pattern as
                    // CharacterAvatar, sized once here and decoded at
                    // display resolution (see TrackMapImage's cacheWidth /
                    // cacheHeight) rather than at the source file's size.
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TrackMapImage(
                        imageAsset: track.imageAsset,
                        fallbackColor: track.tileColor,
                        width: 160,
                        height: 120,
                        borderRadius: BorderRadius.circular(16),
                        flagIconSize: 40,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(track.name,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          track.cup,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(width: AppSpacing.sm),
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
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -24, 0),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(AppSpacing.pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoSection(title: 'Shortcuts', items: track.shortcuts),
                  _InfoSection(title: 'Hazards', items: track.hazards),
                  _InfoSection(title: 'Strategy', items: track.strategyTips),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  ', style: TextStyle(color: AppColors.textSecondary)),
                  Expanded(
                    child: Text(item, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
