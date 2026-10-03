import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/empty_state.dart';
import '../widgets/entity_list_tile.dart';
import '../widgets/favorite_button.dart';
import 'home_screen.dart';
import 'kart_guide_screen.dart';
import 'track_guide_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  void _openTab(BuildContext context, int index) {
    if (index == 3) return; // already on Favorites
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }
    final target = index == 1 ? const TrackGuideScreen() : const KartGuideScreen();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final favorites = appState.favorites.toList();

    return AppScaffold(
      bottomNavigationBar:
          AppBottomNav(currentIndex: 3, onTap: (i) => _openTab(context, i)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Favorites', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text('${favorites.length} saved', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: favorites.isEmpty
                    ? const Center(
                        child: EmptyState(
                          message:
                              'Tap the star on any character, track or kart to save it here.',
                        ),
                      )
                    : ListView.separated(
                        itemCount: favorites.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.listGap),
                        itemBuilder: (context, index) {
                          final entry = favorites[index];
                          final display = _describe(entry);
                          if (display == null) return const SizedBox.shrink();
                          return EntityListTile(
                            name: display.name,
                            subtitle: display.typeLabel,
                            avatarColor: display.color,
                            initials: display.initials,
                            imageAsset: display.imageAsset,
                            trailing: FavoriteButton(
                              isFavorited: true,
                              onToggle: () =>
                                  appState.toggleFavorite(entry.id, entry.type),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _FavoriteDisplay? _describe(FavoriteEntry entry) {
    switch (entry.type) {
      case FavoriteType.character:
        final match = MockData.characters.where((c) => c.id == entry.id);
        if (match.isEmpty) return null;
        final c = match.first;
        return _FavoriteDisplay(c.name, 'Character', c.avatarColor, c.initials,
            imageAsset: c.imageAsset);
      case FavoriteType.track:
        final match = MockData.tracks.where((t) => t.id == entry.id);
        if (match.isEmpty) return null;
        final t = match.first;
        return _FavoriteDisplay(t.name, 'Track', t.tileColor, 'TR');
      case FavoriteType.kart:
        final match = MockData.karts.where((k) => k.id == entry.id);
        if (match.isEmpty) return null;
        final k = match.first;
        return _FavoriteDisplay(
            k.name, 'Kart', AppColors.dataBlue, k.name.substring(0, 2).toUpperCase());
    }
  }
}

class _FavoriteDisplay {
  final String name;
  final String typeLabel;
  final Color color;
  final String initials;
  final String? imageAsset;

  _FavoriteDisplay(this.name, this.typeLabel, this.color, this.initials,
      {this.imageAsset});
}
