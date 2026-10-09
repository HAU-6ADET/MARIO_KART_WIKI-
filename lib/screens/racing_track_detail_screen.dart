import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/app_state.dart';
import '../data/character_extras.dart';
import '../data/mock_data.dart';
import '../data/track_extras.dart';
import '../data/track_layouts.dart';
import '../models/character.dart';
import '../models/kart.dart';
import '../models/track.dart';
import '../theme/theme.dart';
import '../widgets/character_avatar.dart';
import '../widgets/checkered_strip.dart';
import '../widgets/cup_badge.dart';
import '../widgets/difficulty_flags.dart';
import '../widgets/overall_gauge.dart';
import '../widgets/racer_widgets.dart';
import '../widgets/stat_bar.dart';
import '../widgets/track_map.dart';
import '../widgets/track_map_image.dart';
import '../widgets/track_widgets.dart';
import 'character_detail_screen.dart';
import 'kart_detail_screen.dart';

/// Track Detail, styled like a race-day briefing (same family as the racer
/// profile): full-width course image, quick facts, briefing, challenge gauge
/// and course profile, a lap-by-lap plan, shortcuts / hazards / strategy,
/// item tips, recommended racers and karts, the cup lineup and trivia.
class RacingTrackDetailScreen extends StatelessWidget {
  final String trackId;

  const RacingTrackDetailScreen({super.key, required this.trackId});

  double _racerStat(Character c, TrackFocus focus) {
    switch (focus) {
      case TrackFocus.speed:
        return c.speed;
      case TrackFocus.acceleration:
        return c.acceleration;
      case TrackFocus.weight:
        return c.weight;
      case TrackFocus.handling:
        return c.handling;
      case TrackFocus.traction:
        return c.traction;
    }
  }

  double _kartStat(Kart k, TrackFocus focus) {
    switch (focus) {
      case TrackFocus.speed:
        return k.speed;
      case TrackFocus.acceleration:
        return k.acceleration;
      case TrackFocus.weight:
        return k.weight;
      case TrackFocus.handling:
        return k.handling;
      case TrackFocus.traction:
        return k.traction;
    }
  }

  /// Racers who list this track as a best track come first, then the rest;
  /// each group is sorted by the stat that matters most here.
  List<Character> _recommendedRacers(Track track, TrackExtras extras) {
    int byStat(Character a, Character b) => _racerStat(
      b,
      extras.focus,
    ).compareTo(_racerStat(a, extras.focus));
    final preferred = MockData.characters
        .where((c) => CharacterExtras.of(c.id).bestTrackIds.contains(track.id))
        .toList()
      ..sort(byStat);
    final others = MockData.characters
        .where((c) => !preferred.contains(c))
        .toList()
      ..sort(byStat);
    return [...preferred, ...others].take(3).toList();
  }

  List<Kart> _recommendedKarts(TrackExtras extras) {
    final karts = [...MockData.karts]
      ..sort(
        (a, b) => _kartStat(
          b,
          extras.focus,
        ).compareTo(_kartStat(a, extras.focus)),
      );
    return karts.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final track = MockData.tracks.firstWhere((t) => t.id == trackId);
    final appState = AppStateScope.of(context);
    final isFavorited = appState.isFavorited(track.id, FavoriteType.track);
    final textTheme = Theme.of(context).textTheme;
    final extras = TrackExtras.of(track.id);
    final color = racingDifficultyColor(track.difficulty);
    final racers = _recommendedRacers(track, extras);
    final karts = _recommendedKarts(extras);
    final layout = TrackLayout.of(track.id);

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(
              track: track,
              extras: extras,
              isFavorited: isFavorited,
              onFavorite: () =>
                  appState.toggleFavorite(track.id, FavoriteType.track),
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
                            label: 'DIFFICULTY',
                            value: track.difficulty,
                            icon: Icons.flag_rounded,
                            iconColor: color,
                            valueColor: color,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'LAPS',
                            value: '${extras.laps}',
                            icon: Icons.loop_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'SETTING',
                            value: extras.setting,
                            icon: Icons.terrain_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'DEBUT',
                            value: extras.debutYear == 0
                                ? extras.origin
                                : '${extras.debutYear}',
                            icon: Icons.history_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: RacerFactTile(
                            label: 'CUP',
                            value: track.cup,
                            icon: Icons.emoji_events_rounded,
                            iconColor: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'RACE',
                            value: '${extras.raceNumber} of 4',
                            icon: Icons.format_list_numbered_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'TIME',
                            value: extras.timeOfDay.isEmpty
                                ? '-'
                                : extras.timeOfDay,
                            icon: Icons.wb_twilight_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'SURFACE',
                            value: extras.surface.isEmpty ? '-' : extras.surface,
                            icon: Icons.texture_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Briefing ----
                  const PitBoardTitle('Race briefing'),
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
                        Text('Course overview', style: textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(extras.overview, style: textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'First raced in ${extras.origin}.',
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        if (extras.highlights.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md - 4),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              for (final tag in extras.highlights)
                                RacerPill(label: tag, color: color),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Course map ----
                  if (layout != null) ...[
                    const PitBoardTitle('Course map'),
                    const SizedBox(height: AppSpacing.md),
                    TrackMap(layout: layout, color: color),
                    if (extras.sectors.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      const PitBoardTitle('Sector guide'),
                      const SizedBox(height: AppSpacing.md),
                      SectorGuide(sectors: extras.sectors, color: color),
                    ],
                    const SizedBox(height: AppSpacing.sectionGap),
                  ],

                  // ---- Pit board: challenge + course profile ----
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
                          rating: extras.challenge,
                          color: color,
                          caption: 'CHALLENGE',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DifficultyFlags(difficulty: track.difficulty, size: 22),
                        const SizedBox(height: AppSpacing.md),
                        StatBar(
                          label: 'Straights',
                          value: extras.straights,
                          color: color,
                        ),
                        StatBar(
                          label: 'Corners',
                          value: extras.corners,
                          color: color,
                        ),
                        StatBar(
                          label: 'Off-road',
                          value: extras.offRoad,
                          color: color,
                        ),
                        StatBar(
                          label: 'Danger',
                          value: extras.hazardLevel,
                          color: color,
                        ),
                        StatBar(
                          label: 'Shortcut',
                          value: extras.shortcutPotential,
                          color: color,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Challenge and course profile are wiki estimates, '
                          'not official game stats.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---- Lap plan ----
                  if (extras.lapPlan.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sectionGap),
                    const PitBoardTitle('Lap-by-lap plan'),
                    const SizedBox(height: AppSpacing.md),
                    LapPlanTimeline(steps: extras.lapPlan, color: color),
                  ],
                  if (extras.skillTips.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sectionGap),
                    const PitBoardTitle('Skill tips'),
                    const SizedBox(height: AppSpacing.md),
                    SkillTips(tips: extras.skillTips),
                  ],
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Shortcuts / hazards / strategy / items ----
                  StripedInfoList(
                    title: 'Shortcuts',
                    icon: Icons.alt_route_rounded,
                    color: AppColors.success,
                    items: track.shortcuts,
                  ),
                  StripedInfoList(
                    title: 'Hazards',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.secondary,
                    items: track.hazards,
                  ),
                  StripedInfoList(
                    title: 'Common mistakes',
                    icon: Icons.report_gmailerrorred_rounded,
                    color: AppColors.primary,
                    items: extras.mistakes,
                  ),
                  StripedInfoList(
                    title: 'Strategy',
                    icon: Icons.speed_rounded,
                    color: AppColors.primary,
                    items: track.strategyTips,
                  ),
                  StripedInfoList(
                    title: 'Item tips',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.dataBlue,
                    items: extras.itemTips,
                  ),

                  // ---- Best racers ----
                  const SizedBox(height: AppSpacing.md),
                  const PitBoardTitle('Best racers here'),
                  const SizedBox(height: AppSpacing.sm),
                  if (extras.focusReason.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        'Key stat: ${extras.focus.label}. ${extras.focusReason}',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  for (final racer in racers)
                    MiniLinkCard(
                      leading: CharacterAvatar(
                        initials: racer.initials,
                        color: racer.avatarColor,
                        imageAsset: racer.imageAsset,
                        radius: 24,
                      ),
                      title: racer.name,
                      subtitle:
                          '${racer.characterClass.label} · '
                          '${extras.focus.label} '
                          '${(_racerStat(racer, extras.focus) * 100).round()}',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              CharacterDetailScreen(characterId: racer.id),
                        ),
                      ),
                    ),

                  // ---- Best karts ----
                  const SizedBox(height: AppSpacing.md),
                  const PitBoardTitle('Recommended karts'),
                  const SizedBox(height: AppSpacing.md),
                  for (final kart in karts)
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
                          '${extras.focus.label} '
                          '${(_kartStat(kart, extras.focus) * 100).round()} · '
                          'SPD ${(kart.speed * 100).round()} · '
                          'HDL ${(kart.handling * 100).round()}',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => KartDetailScreen(kartId: kart.id),
                        ),
                      ),
                    ),

                  // ---- Cup lineup ----
                  if (extras.cupLineup.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    const PitBoardTitle('Cup lineup'),
                    const SizedBox(height: AppSpacing.md),
                    CupLineup(
                      cup: track.cup,
                      courses: extras.cupLineup,
                      currentIndex: extras.raceNumber - 1,
                      color: color,
                    ),
                  ],

                  // ---- Trivia ----
                  const SizedBox(height: AppSpacing.sectionGap),
                  StripedInfoList(
                    title: 'Did you know?',
                    icon: Icons.lightbulb_rounded,
                    color: AppColors.secondary,
                    items: extras.funFacts,
                  ),
                  Text(
                    'Cups, race order and lineups are for Mario Kart 8 Deluxe.',
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
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
  final Track track;
  final TrackExtras extras;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const _Hero({
    required this.track,
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
        final height = width * 9 / 16 + MediaQuery.paddingOf(context).top;
        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              TrackMapImage(
                imageAsset: track.imageAsset,
                fallbackColor: track.tileColor,
                width: width,
                height: height,
                flagIconSize: 64,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.88),
                      ],
                      stops: const [0, 0.35, 1],
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
                    CupBadge(cup: track.cup, raceNumber: extras.raceNumber),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      track.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (extras.tagline.isNotEmpty)
                      Text(
                        extras.tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
