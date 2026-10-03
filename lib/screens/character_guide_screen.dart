import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../models/character.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/checkered_strip.dart';
import '../widgets/racer_card.dart';
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
    CharacterClass.lightweight,
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
        : MockData.characters
              .where((c) => c.characterClass == _filter)
              .toList();
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Characters',
          style: textTheme.headlineSmall?.copyWith(fontStyle: FontStyle.italic),
        ),
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
          const CheckeredStrip(height: 8),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 40,
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
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pad,
              AppSpacing.sm,
              AppSpacing.pad,
              AppSpacing.sm,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${visible.length} on the grid · tap a card for the full driver profile',
                style: textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      'No racers in this class yet.',
                      style: textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pad,
                      AppSpacing.xs,
                      AppSpacing.pad,
                      AppSpacing.pad,
                    ),
                    itemCount: visible.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.listGap),
                    itemBuilder: (context, index) {
                      final character = visible[index];
                      return RacerCard(
                        character: character,
                        onTap: () {
                          AppStateScope.of(
                            context,
                          ).markCharacterViewed(character.id);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CharacterDetailScreen(
                                characterId: character.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
