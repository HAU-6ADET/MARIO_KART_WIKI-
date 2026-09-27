import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../theme/theme.dart';

/// NOTE: extrapolated — mockup.pdf only describes this screen in a caption
/// ("Track Detail screen (shortcuts, hazards, strategy — same pattern as
/// Character Detail)") without an actual mockup frame. Revisit once a real
/// design exists.
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
          SliverAppBar(
            backgroundColor: track.tileColor,
            expandedHeight: 160,
            pinned: true,
            leading: const BackButton(color: Colors.black87),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.black87,
                ),
                onPressed: () =>
                    appState.toggleFavorite(track.id, FavoriteType.track),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: Text(track.name,
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              background: const Center(
                child: Icon(Icons.flag_rounded, size: 56, color: Colors.black38),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(track.cup, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  const SizedBox(height: AppSpacing.sectionGap),
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
