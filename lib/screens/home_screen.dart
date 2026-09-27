import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/category_card.dart';
import '../widgets/character_avatar.dart';
import 'character_detail_screen.dart';
import 'character_guide_screen.dart';
import 'favorites_screen.dart';
import 'kart_guide_screen.dart';
import 'track_guide_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openTab(BuildContext context, int index) {
    switch (index) {
      case 0:
        break; // already home
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TrackGuideScreen()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KartGuideScreen()));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final recentIds = appState.recentlyViewedCharacterIds;
    final recentCharacters = recentIds
        .map((id) => MockData.characters.where((c) => c.id == id))
        .where((matches) => matches.isNotEmpty)
        .map((matches) => matches.first)
        .toList();
    final showRecent = recentCharacters.isNotEmpty
        ? recentCharacters
        : MockData.characters.take(4).toList(); // sensible default before anything's been viewed

    return Scaffold(
      bottomNavigationBar: AppBottomNav(currentIndex: 0, onTap: (i) => _openTab(context, i)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mario Kart World Wiki', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'Every character, track & kart in one place',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  hintText: 'Search characters, tracks, karts...',
                ),
                onSubmitted: (query) {
                  // TODO: wire up real search once a search-results screen is designed.
                },
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _CategoryGrid(onOpenTab: (i) => _openTab(context, i)),
              const SizedBox(height: AppSpacing.sectionGap),
              Text('Recently viewed', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: showRecent.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final character = showRecent[index];
                    return GestureDetector(
                      onTap: () {
                        appState.markCharacterViewed(character.id);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CharacterDetailScreen(characterId: character.id),
                        ));
                      },
                      child: Column(
                        children: [
                          CharacterAvatar(
                            initials: character.initials,
                            color: character.avatarColor,
                            imageAsset: character.imageAsset,
                            radius: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(character.name, style: Theme.of(context).textTheme.labelSmall),
                        ],
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
}

class _CategoryGrid extends StatelessWidget {
  final ValueChanged<int> onOpenTab;

  const _CategoryGrid({required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // A fixed mainAxisExtent (rather than childAspectRatio) keeps this
      // card's icon + title + subtitle from overflowing on narrower phones,
      // where an aspect-ratio cell shrinks in both directions at once and
      // there isn't enough vertical room left for three stacked children.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.listGap,
        crossAxisSpacing: AppSpacing.listGap,
        mainAxisExtent: 132,
      ),
      children: [
        CategoryCard(
          title: 'Characters',
          subtitle: '${MockData.characters.length} racers',
          icon: Icons.star_rounded,
          accent: AppColors.primary,
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const CharacterGuideScreen())),
        ),
        CategoryCard(
          title: 'Tracks',
          subtitle: '${MockData.tracks.length} courses',
          icon: Icons.flag_rounded,
          accent: AppColors.dataBlue,
          onTap: () => onOpenTab(1),
        ),
        CategoryCard(
          title: 'Karts & Bikes',
          subtitle: '${MockData.karts.length} vehicles',
          icon: Icons.directions_car_filled_rounded,
          accent: AppColors.secondary,
          onTap: () => onOpenTab(2),
        ),
        CategoryCard(
          title: 'Favorites',
          subtitle: 'Your saved list',
          icon: Icons.star_rounded,
          accent: const Color(0xFFF178A6),
          onTap: () => onOpenTab(3),
        ),
      ],
    );
  }
}
