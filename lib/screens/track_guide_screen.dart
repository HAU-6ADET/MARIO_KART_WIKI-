import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/racing_track_card.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'kart_guide_screen.dart';
import 'racing_track_detail_screen.dart';

class TrackGuideScreen extends StatelessWidget {
  const TrackGuideScreen({super.key});

  void _openTab(BuildContext context, int index) {
    if (index == 1) return; // already on Tracks
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }
    final target = index == 2 ? const KartGuideScreen() : const FavoritesScreen();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Tracks'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      bottomNavigationBar:
          AppBottomNav(currentIndex: 1, onTap: (i) => _openTab(context, i)),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pad),
        itemCount: MockData.tracks.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.listGap),
        itemBuilder: (context, index) {
          final track = MockData.tracks[index];
          return RacingTrackCard(
            track: track,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => RacingTrackDetailScreen(trackId: track.id)),
            ),
          );
        },
      ),
    );
  }
}
