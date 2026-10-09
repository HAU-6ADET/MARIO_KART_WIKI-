import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../data/kart_extras.dart';
import '../data/mock_data.dart';
import '../data/track_extras.dart';
import '../models/character.dart';
import '../models/kart.dart';
import '../models/track.dart';
import '../theme/theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/character_avatar.dart';
import '../widgets/checkered_strip.dart';
import '../widgets/overall_gauge.dart';
import '../widgets/racer_widgets.dart';
import '../widgets/stat_bar.dart';
import '../widgets/track_map_image.dart';
import 'character_detail_screen.dart';
import 'racing_track_detail_screen.dart';

/// Kart / bike profile, in the same family as the racer and track pages:
/// a blue hero, a checkered strip, quick facts, a garage briefing, an overall
/// gauge with ranked stats, a comparison with the rest of the garage,
/// strengths and weaknesses, setup tips, and links to racers and courses
/// that suit it.
class KartDetailScreen extends StatelessWidget {
  final String kartId;

  const KartDetailScreen({super.key, required this.kartId});

  /// Racers who list this kart as a good pairing.
  List<Character> _pairedRacers(Kart kart) => MockData.characters
      .where((c) => c.bestPairedWithKartIds.contains(kart.id))
      .toList();

  /// Racers strongest in this kart's weakest stat (they cover the gap).
  List<Character> _coverRacers(Kart kart, TrackFocus weak, List<Character> skip) {
    final list = MockData.characters.where((c) => !skip.contains(c)).toList()
      ..sort((a, b) => racerStat(b, weak).compareTo(racerStat(a, weak)));
    return list.take(2).toList();
  }

  /// Courses where the stat that matters most is this kart's strength.
  List<Track> _bestTracks(Kart kart) {
    final list = [...MockData.tracks]
      ..sort((a, b) {
        double v(Track t) => kartStat(kart, TrackExtras.of(t.id).focus);
        return v(b).compareTo(v(a));
      });
    return list.take(2).toList();
  }

  @override
  Widget build(BuildContext context) {
    final kart = MockData.karts.firstWhere((k) => k.id == kartId);
    final extras = KartExtras.of(kart.id);
    final appState = AppStateScope.of(context);
    final isFavorited = appState.isFavorited(kart.id, FavoriteType.kart);
    final textTheme = Theme.of(context).textTheme;

    final top = kartTopStat(kart);
    final weak = kartWeakStat(kart);
    final paired = _pairedRacers(kart);
    final cover = weak == null ? <Character>[] : _coverRacers(kart, weak, paired);
    final tracks = _bestTracks(kart);

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Hero(
              kart: kart,
              extras: extras,
              isFavorited: isFavorited,
              onFavorite: () =>
                  appState.toggleFavorite(kart.id, FavoriteType.kart),
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
                            label: 'TYPE',
                            value: extras.type,
                            icon: extras.isBike
                                ? Icons.two_wheeler_rounded
                                : Icons.directions_car_filled_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'WEIGHT',
                            value: kartWeightClass(kart),
                            icon: Icons.fitness_center_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'TOP STAT',
                            value: top.label,
                            icon: Icons.bolt_rounded,
                            iconColor: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: RacerFactTile(
                            label: 'WEAK SPOT',
                            value: weak?.label ?? 'None',
                            icon: Icons.trending_down_rounded,
                            iconColor: weak == null
                                ? AppColors.textSecondary
                                : AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Briefing ----
                  const PitBoardTitle('Garage briefing'),
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
                        Text(extras.overview, style: textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Best for', style: textTheme.titleMedium),
                        const SizedBox(height: 2),
                        Text(extras.bestFor, style: textTheme.bodyMedium),
                        if (extras.highlights.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md - 4),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              for (final tag in extras.highlights)
                                RacerPill(label: tag, color: AppColors.dataBlue),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Stats ----
                  const PitBoardTitle('Stats'),
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
                          rating: kartOverall(kart),
                          color: AppColors.dataBlue,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        for (final f in TrackFocus.values)
                          StatBar(
                            label: f.label,
                            value: kartStat(kart, f),
                            color: AppColors.dataBlue,
                            note: '#${kartRank(kart, f)}',
                          ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '#1 is the best in the garage. Stats are wiki '
                          'estimates, not official game numbers.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Versus the garage ----
                  const PitBoardTitle('Vs. the garage'),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      children: [
                        for (final f in TrackFocus.values)
                          _DeltaRow(
                            label: f.label,
                            delta:
                                ((kartStat(kart, f) - garageAverage(f)) * 100)
                                    .round(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs + 2),
                  Text(
                    'Compared with the average of every kart and bike here.',
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ---- Pros, cons, tips ----
                  StripedInfoList(
                    title: 'Strengths',
                    icon: Icons.thumb_up_alt_rounded,
                    color: AppColors.success,
                    items: extras.strengths,
                  ),
                  StripedInfoList(
                    title: 'Weaknesses',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.secondary,
                    items: extras.weaknesses,
                  ),
                  StripedInfoList(
                    title: 'Setup tips',
                    icon: Icons.tune_rounded,
                    color: AppColors.primary,
                    items: extras.tips,
                  ),

                  // ---- Racers ----
                  if (paired.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    const PitBoardTitle('Pairs well with'),
                    const SizedBox(height: AppSpacing.md),
                    for (final racer in paired)
                      _RacerLink(
                        racer: racer,
                        subtitle: '${racer.characterClass.label} · listed '
                            'as a good pairing',
                      ),
                  ],
                  if (cover.isNotEmpty && weak != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    const PitBoardTitle('Covers its weak spot'),
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        '${weak.label} is this vehicle\'s lowest stat. These '
                        'racers are strongest there.',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    for (final racer in cover)
                      _RacerLink(
                        racer: racer,
                        subtitle:
                            '${weak.label} ${(racerStat(racer, weak) * 100).round()}',
                      ),
                  ],

                  // ---- Courses ----
                  const SizedBox(height: AppSpacing.md),
                  const PitBoardTitle('Great on these courses'),
                  const SizedBox(height: AppSpacing.md),
                  for (final track in tracks)
                    MiniLinkCard(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: TrackMapImage(
                          imageAsset: track.imageAsset,
                          fallbackColor: track.tileColor,
                          width: 56,
                          height: 40,
                          flagIconSize: 20,
                        ),
                      ),
                      title: track.name,
                      subtitle:
                          'Key stat ${TrackExtras.of(track.id).focus.label} '
                          '${(kartStat(kart, TrackExtras.of(track.id).focus) * 100).round()}',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              RacingTrackDetailScreen(trackId: track.id),
                        ),
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
  final Kart kart;
  final KartExtras extras;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const _Hero({
    required this.kart,
    required this.extras,
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final icon = extras.isBike
        ? Icons.two_wheeler_rounded
        : Icons.directions_car_filled_rounded;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.dataBlue,
            AppColors.dataBlue.withValues(alpha: 0.55),
            AppColors.background,
          ],
          stops: const [0, 0.55, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -8,
            child: Icon(
              icon,
              size: 190,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.xs,
                AppSpacing.sm,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md - 4,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 48,
                            color: AppColors.dataBlue,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RacerPill(
                                label: extras.type,
                                color: Colors.white,
                                icon: icon,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                kart.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
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
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md - 4,
                    ),
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _HeroChip(
                          icon: Icons.speed_rounded,
                          iconColor: AppColors.secondary,
                          text: 'OVERALL ${kartOverall(kart)}',
                        ),
                        _HeroChip(
                          icon: Icons.emoji_events_rounded,
                          iconColor: AppColors.secondary,
                          text: '#${kartRank(kart, kartTopStat(kart))} IN '
                              '${kartTopStat(kart).label.toUpperCase()}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _HeroChip({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeltaRow extends StatelessWidget {
  final String label;
  final int delta;

  const _DeltaRow({required this.label, required this.delta});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = delta > 0
        ? AppColors.success
        : (delta < 0 ? AppColors.primary : AppColors.textSecondary);
    final text = delta > 0 ? '+$delta' : '$delta';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: textTheme.bodyMedium)),
          Icon(
            delta > 0
                ? Icons.arrow_drop_up_rounded
                : (delta < 0
                      ? Icons.arrow_drop_down_rounded
                      : Icons.remove_rounded),
            color: color,
          ),
          SizedBox(
            width: 40,
            child: Text(
              text,
              textAlign: TextAlign.end,
              style: textTheme.labelSmall?.copyWith(color: color, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _RacerLink extends StatelessWidget {
  final Character racer;
  final String subtitle;

  const _RacerLink({required this.racer, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return MiniLinkCard(
      leading: CharacterAvatar(
        initials: racer.initials,
        color: racer.avatarColor,
        imageAsset: racer.imageAsset,
        radius: 24,
      ),
      title: racer.name,
      subtitle: subtitle,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CharacterDetailScreen(characterId: racer.id),
        ),
      ),
    );
  }
}
