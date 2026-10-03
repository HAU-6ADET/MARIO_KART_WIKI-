import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/app_state.dart';
import '../data/character_extras.dart';
import '../data/mock_data.dart';
import '../models/character.dart';
import '../models/kart.dart';
import '../models/track.dart';
import '../theme/theme.dart';
import '../widgets/checkered_strip.dart';
import '../widgets/overall_gauge.dart';
import '../widgets/racer_widgets.dart';
import '../widgets/stat_bar.dart';
import '../widgets/track_map_image.dart';
import 'kart_detail_screen.dart';
import 'racing_track_detail_screen.dart';

/// Driver profile, styled like a race-day briefing (same family as the
/// track detail): full-width racer picture with number plate, a checkered
/// strip, quick facts, bio and playstyle, a pit board of stats with an
/// overall gauge, strengths / weaknesses, best kart setups, best tracks,
/// how to unlock, and some trivia.
class CharacterDetailScreen extends StatelessWidget {
  final String characterId;

  const CharacterDetailScreen({super.key, required this.characterId});

  /// Roster rank for one stat, e.g. "#2" (1 = highest of all racers).
  String _rank(Character character, double Function(Character) pick) {
    final better = MockData.characters
        .where((other) => pick(other) > pick(character))
        .length;
    return '#${better + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final character = MockData.characters.firstWhere(
      (c) => c.id == characterId,
    );
    final extras = CharacterExtras.of(character.id);
    final appState = AppStateScope.of(context);
    final isFavorited = appState.isFavorited(
      character.id,
      FavoriteType.character,
    );
    final textTheme = Theme.of(context).textTheme;
    final color = character.avatarColor;

    final pairedKarts = character.bestPairedWithKartIds
        .map(MockData.kartById)
        .whereType<Kart>()
        .toList();
    final bestTracks = [
      for (final id in extras.bestTrackIds)
        for (final track in MockData.tracks)
          if (track.id == id) track,
    ];

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(
              character: character,
              extras: extras,
              isFavorited: isFavorited,
              onFavorite: () =>
                  appState.toggleFavorite(character.id, FavoriteType.character),
            ),
            const CheckeredStrip(height: 14),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Quick facts ----
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: RacerFactTile(
                            label: 'CLASS',
                            value: character.characterClass.label,
                            icon: Icons.speed_rounded,
                            iconColor: color,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'STATUS',
                            value: character.unlocked ? 'Unlocked' : 'Locked',
                            icon: character.unlocked
                                ? Icons.lock_open_rounded
                                : Icons.lock_rounded,
                            iconColor: character.unlocked
                                ? AppColors.success
                                : AppColors.primary,
                            valueColor: character.unlocked
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'SPECIES',
                            value: extras.species,
                            icon: Icons.face_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'KART DEBUT',
                            value: '${extras.kartDebutYear}',
                            icon: Icons.history_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Driver profile ----
                  const PitBoardTitle('Driver profile'),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(extras.bio, style: textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.md),
                        const Divider(height: 1),
                        const SizedBox(height: AppSpacing.md),
                        _LabeledText(
                          label: 'PLAYSTYLE',
                          text: extras.playstyle,
                          color: color,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _LabeledText(
                          label: 'FIRST APPEARED',
                          text: extras.debut,
                          color: color,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _LabeledText(
                          label: 'MARIO KART DEBUT',
                          text: '${extras.kartDebut} (${extras.kartDebutYear})',
                          color: color,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Pit board (stats) ----
                  const PitBoardTitle('Pit board'),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        OverallGauge(
                          rating: character.overallRating,
                          color: color,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        RacerPill(
                          label: 'Top stat: ${character.topStat}',
                          color: color,
                          icon: Icons.bolt_rounded,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Overall = average of speed, acceleration, handling and traction.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(fontSize: 11),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        StatBar(
                          label: 'Speed',
                          value: character.speed,
                          color: color,
                          note: _rank(character, (c) => c.speed),
                        ),
                        StatBar(
                          label: 'Acceleration',
                          value: character.acceleration,
                          color: color,
                          note: _rank(character, (c) => c.acceleration),
                        ),
                        StatBar(
                          label: 'Weight',
                          value: character.weight,
                          color: color,
                          note: _rank(character, (c) => c.weight),
                        ),
                        StatBar(
                          label: 'Handling',
                          value: character.handling,
                          color: color,
                          note: _rank(character, (c) => c.handling),
                        ),
                        StatBar(
                          label: 'Traction',
                          value: character.traction,
                          color: color,
                          note: _rank(character, (c) => c.traction),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Rank among ${MockData.characters.length} racers',
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 10,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Strengths / weaknesses ----
                  StripedInfoList(
                    title: 'Strengths',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    items: extras.strengths,
                  ),
                  StripedInfoList(
                    title: 'Weaknesses',
                    icon: Icons.error_outline_rounded,
                    color: AppColors.primary,
                    items: extras.weaknesses,
                  ),

                  // ---- Best kart setups ----
                  if (pairedKarts.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    const PitBoardTitle('Best setups'),
                    const SizedBox(height: AppSpacing.md),
                    for (final kart in pairedKarts)
                      MiniLinkCard(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.dataBlue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.directions_car_filled_rounded,
                            color: AppColors.dataBlue,
                          ),
                        ),
                        title: kart.name,
                        subtitle:
                            'SPD ${(kart.speed * 100).round()} · '
                            'ACC ${(kart.acceleration * 100).round()} · '
                            'HDL ${(kart.handling * 100).round()}',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => KartDetailScreen(kartId: kart.id),
                          ),
                        ),
                      ),
                  ],

                  // ---- Best tracks ----
                  if (bestTracks.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    const PitBoardTitle('Best tracks'),
                    const SizedBox(height: AppSpacing.md),
                    for (final Track track in bestTracks)
                      MiniLinkCard(
                        leading: TrackMapImage(
                          imageAsset: track.imageAsset,
                          fallbackColor: track.tileColor,
                          width: 72,
                          height: 48,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: track.name,
                        subtitle: '${track.cup} · ${track.difficulty}',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                RacingTrackDetailScreen(trackId: track.id),
                          ),
                        ),
                      ),
                  ],

                  // ---- How to unlock ----
                  const SizedBox(height: AppSpacing.md),
                  const PitBoardTitle('How to unlock'),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                character.unlockTitle,
                                style: textTheme.titleMedium,
                              ),
                              Text(
                                character.unlockDescription,
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---- Trivia ----
                  const SizedBox(height: AppSpacing.sectionGap),
                  StripedInfoList(
                    title: 'Pit talk',
                    icon: Icons.lightbulb_rounded,
                    color: AppColors.secondary,
                    items: extras.funFacts,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final Character character;
  final CharacterExtras extras;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const _Hero({
    required this.character,
    required this.extras,
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width * 0.95 + MediaQuery.paddingOf(context).top;
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: RacerImage(
                  imageAsset: character.imageAsset,
                  color: character.avatarColor,
                  initials: character.initials,
                  width: width,
                  height: height,
                ),
              ),
              // Dark fades so the buttons and name stay readable.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.9),
                      ],
                      stops: const [0, 0.4, 1],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorited
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.secondary,
                          size: 28,
                        ),
                        onPressed: onFavorite,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.pad,
                right: AppSpacing.pad,
                bottom: AppSpacing.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        RacerNumberBadge(
                          number: extras.racerNumber,
                          color: character.avatarColor,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        RacerPill(
                          label: character.characterClass.label.toUpperCase(),
                          color: character.avatarColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      character.name,
                      style: textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      extras.tagline,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Small caps label above a line of text, with a colored tick.
class _LabeledText extends StatelessWidget {
  final String label;
  final String text;
  final Color color;

  const _LabeledText({
    required this.label,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 10, height: 3, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.onSurface),
        ),
      ],
    );
  }
}
