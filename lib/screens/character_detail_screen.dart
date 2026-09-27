import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../models/character.dart';
import '../models/kart.dart';
import '../theme/theme.dart';
import '../widgets/stat_bar.dart';

class CharacterDetailScreen extends StatelessWidget {
  final String characterId;

  const CharacterDetailScreen({super.key, required this.characterId});

  Widget _initialsFallback(Character character) {
    return Center(
      child: Text(
        character.initials,
        style: TextStyle(
          color: character.avatarColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = MockData.characters.firstWhere((c) => c.id == characterId);
    final appState = AppStateScope.of(context);
    final isFavorited = appState.isFavorited(character.id, FavoriteType.character);

    final pairedKarts = character.bestPairedWithKartIds
        .map(MockData.kartById)
        .whereType<Kart>()
        .toList();

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
                  colors: [character.avatarColor, AppColors.background],
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
                          onPressed: () => appState.toggleFavorite(
                              character.id, FavoriteType.character),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: character.imageAsset != null
                          ? ClipOval(
                              child: Image.asset(
                                character.imageAsset!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _initialsFallback(character),
                              ),
                            )
                          : _initialsFallback(character),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(character.name,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      '${character.subtitle} · ${character.unlocked ? "Unlocked from start" : "Locked"}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
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
                  Text('Stats', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  StatBar(label: 'Speed', value: character.speed),
                  StatBar(label: 'Acceleration', value: character.acceleration),
                  StatBar(label: 'Weight', value: character.weight),
                  StatBar(label: 'Handling', value: character.handling),
                  StatBar(label: 'Traction', value: character.traction),
                  const SizedBox(height: AppSpacing.sectionGap),
                  Text('How to unlock', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events, color: AppColors.secondary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(character.unlockTitle,
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text(character.unlockDescription,
                                  style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (pairedKarts.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sectionGap),
                    Text('Best paired with', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        for (final kart in pairedKarts) ...[
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.directions_car_filled_rounded,
                                      color: AppColors.dataBlue),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(kart.name,
                                      style: Theme.of(context).textTheme.labelSmall),
                                ],
                              ),
                            ),
                          ),
                          if (kart != pairedKarts.last) const SizedBox(width: AppSpacing.sm),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
