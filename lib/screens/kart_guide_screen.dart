import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/entity_list_tile.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'kart_detail_screen.dart';
import 'track_guide_screen.dart';

/// NOTE: extrapolated — no Karts & Bikes mockup exists (see README "Known
/// issues"). Built to keep the Karts bottom-nav tab functional, following
/// the same EntityListTile pattern used on Character Guide.
class KartGuideScreen extends StatelessWidget {
  const KartGuideScreen({super.key});

  void _openTab(BuildContext context, int index) {
    if (index == 2) return; // already on Karts
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }
    final target = index == 1 ? const TrackGuideScreen() : const FavoritesScreen();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Karts & Bikes')),
      bottomNavigationBar:
          AppBottomNav(currentIndex: 2, onTap: (i) => _openTab(context, i)),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.pad),
        itemCount: MockData.karts.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.listGap),
        itemBuilder: (context, index) {
          final kart = MockData.karts[index];
          return EntityListTile(
            name: kart.name,
            subtitle: 'Kart',
            avatarColor: AppColors.dataBlue,
            initials: kart.name.substring(0, 2).toUpperCase(),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => KartDetailScreen(kartId: kart.id)),
            ),
          );
        },
      ),
    );
  }
}
