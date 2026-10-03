/// Extra racing facts for each track, kept separate from the core [Track]
/// model so that model stays unchanged. Looked up by track id.
///
/// Cup, race order and debut game are for the Mario Kart 8 Deluxe version of
/// each course, matching the screenshots in assets/tracks/.
class TrackExtras {
  final String overview;
  final int raceNumber; // position inside its cup (1-4)
  final String origin; // game the course first appeared in
  final String setting;
  final int laps;

  const TrackExtras({
    required this.overview,
    required this.raceNumber,
    required this.origin,
    required this.setting,
    this.laps = 3,
  });

  static const TrackExtras fallback = TrackExtras(
    overview: 'Course details coming soon.',
    raceNumber: 1,
    origin: 'Mario Kart',
    setting: 'Circuit',
  );

  static TrackExtras of(String trackId) => _byId[trackId] ?? fallback;

  static const Map<String, TrackExtras> _byId = {
    'moo_moo_meadows': TrackExtras(
      overview:
          'A sunny farmland circuit with windmills, wide grassy bends and cows '
          'that wander onto the road. Short weaving turns make it a gentle '
          'first race.',
      raceNumber: 1,
      origin: 'Mario Kart Wii',
      setting: 'Countryside',
    ),
    'dry_dry_dessert': TrackExtras(
      overview:
          'A sun-baked desert run that starts between two giant sphinx '
          'statues. Soft sand lines the road and ruined pillars narrow the '
          'racing line.',
      raceNumber: 1,
      origin: 'Mario Kart: Double Dash!!',
      setting: 'Desert',
    ),
    'royal_raceway': TrackExtras(
      overview:
          "A classic grand-prix circuit around Peach's castle grounds, with a "
          'big grandstand, a lake and a wide road that rewards a clean '
          'racing line.',
      raceNumber: 3,
      origin: 'Mario Kart 64',
      setting: 'Castle Grounds',
    ),
    'rainbow_road': TrackExtras(
      overview:
          'The Special Cup finale: a glowing night-sky course with '
          'anti-gravity sections and long drops, where one mistake can send '
          'you off the edge.',
      raceNumber: 4,
      origin: 'Mario Kart 8',
      setting: 'Sky / Space',
    ),
  };
}
