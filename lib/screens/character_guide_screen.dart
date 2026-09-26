import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../models/character.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/entity_list_tile.dart';
import '../widgets/unlock_status_icon.dart';
import 'character_detail_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'kart_guide_screen.dart';
import 'track_guide_screen.dart';

class CharacterGuideScreen extends StatefulWidget {
  const CharacterGuideScreen({super.key});

  @override
  State<CharacterGuideScreen> createState() => _CharacterGuideScreenState();
}

class _CharacterGuideScreenState extends State<CharacterGuideScreen> {
  CharacterClass? _filter; // null == "All"

  static const _filters = <CharacterClass?>[
    null,
    CharacterClass.speed,
    CharacterClass.balanced,
    CharacterClass.heavy,
  ];

  void _openTab(int index) {
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }
    final target = switch (index) {
      1 => const TrackGuideScreen(),
      2 => const KartGuideScreen(),
      _ => const FavoritesScreen(),
    };
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    final visible = _filter == null
        ? MockData.characters
        : MockData.characters.where((c) => c.characterClass == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {}, // TODO: search results screen not yet designed
          ),
        ],
      ),
      // Character Guide has no tab of its own — Home stays highlighted,
      // matching the mockup.
      bottomNavigationBar: AppBottomNav(currentIndex: 0, onTap: _openTab),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pad),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final classFilter = _filters[index];
                final label = classFilter?.label ?? 'All';
                final selected = _filter == classFilter;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = classFilter),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surfaceHigh,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  side: BorderSide.none,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pad),
              itemCount: visible.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.listGap),
              itemBuilder: (context, index) {
                final character = visible[index];
                return EntityListTile(
                  name: character.name,
                  subtitle: character.characterClass.label,
                  avatarColor: character.avatarColor,
                  initials: character.initials,
                  imageAsset: character.imageAsset,
                  trailing: UnlockStatusIcon(unlocked: character.unlocked),
                  onTap: () {
                    AppStateScope.of(context).markCharacterViewed(character.id);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => CharacterDetailScreen(characterId: character.id),
                    ));
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
