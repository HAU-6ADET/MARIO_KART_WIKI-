import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/checkered_strip.dart';
import '../widgets/difficulty_flags.dart';
import '../widgets/racing_track_card.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'kart_guide_screen.dart';
import 'racing_track_detail_screen.dart';

class TrackGuideScreen extends StatefulWidget {
  const TrackGuideScreen({super.key});

  @override
  State<TrackGuideScreen> createState() => _TrackGuideScreenState();
}

class _TrackGuideScreenState extends State<TrackGuideScreen> {
  String? _difficulty; // null == "All"

  static const _filters = <String?>[null, 'Easy', 'Medium', 'Hard'];

  void _openTab(BuildContext context, int index) {
    if (index == 1) return; // already on Tracks
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }
    final target = index == 2
        ? const KartGuideScreen()
        : const FavoritesScreen();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    final visible = _difficulty == null
        ? MockData.tracks
        : MockData.tracks.where((t) => t.difficulty == _difficulty).toList();

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Tracks'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (i) => _openTab(context, i),
      ),
      body: Column(
        children: [
          // Plain Wrap (not a scrolling row) so the page has one scroll view.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pad),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final filter in _filters)
                    ChoiceChip(
                      avatar: Icon(
                        Icons.flag_rounded,
                        size: 16,
                        color: _difficulty == filter
                            ? Colors.black87
                            : (filter == null
                                  ? AppColors.textSecondary
                                  : racingDifficultyColor(filter)),
                      ),
                      label: Text(filter ?? 'All'),
                      showCheckmark: false,
                      selected: _difficulty == filter,
                      onSelected: (_) => setState(() => _difficulty = filter),
                      selectedColor: filter == null
                          ? AppColors.primary
                          : racingDifficultyColor(filter),
                      backgroundColor: AppColors.surfaceHigh,
                      labelStyle: TextStyle(
                        color: _difficulty == filter
                            ? Colors.black87
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide.none,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const CheckeredStrip(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pad,
              AppSpacing.md - 4,
              AppSpacing.pad,
              0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${visible.length} courses on the calendar',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pad),
              itemCount: visible.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.listGap),
              itemBuilder: (context, index) {
                final track = visible[index];
                return RacingTrackCard(
                  track: track,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RacingTrackDetailScreen(trackId: track.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
