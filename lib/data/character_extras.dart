import '../models/character.dart';

/// Extra driver-profile info for each character, kept separate from the core
/// [Character] model so that model stays unchanged (same pattern as
/// TrackExtras). Looked up by character id.
///
/// Debut games and years are series facts. [racerNumber] is just the roster
/// order, used as a race-number badge in the UI.
class CharacterExtras {
  final int racerNumber;
  final String tagline;
  final String bio;
  final String playstyle;
  final String species;
  final String debut; // character's first-ever game
  final String kartDebut; // first Mario Kart game they raced in
  final int kartDebutYear;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> funFacts;
  final List<String> bestTrackIds;

  const CharacterExtras({
    required this.racerNumber,
    required this.tagline,
    required this.bio,
    required this.playstyle,
    required this.species,
    required this.debut,
    required this.kartDebut,
    required this.kartDebutYear,
    this.strengths = const [],
    this.weaknesses = const [],
    this.funFacts = const [],
    this.bestTrackIds = const [],
  });

  static const CharacterExtras fallback = CharacterExtras(
    racerNumber: 0,
    tagline: 'Mushroom Kingdom racer',
    bio: 'Driver details coming soon.',
    playstyle: 'Find your own racing line.',
    species: 'Unknown',
    debut: 'Mario Kart',
    kartDebut: 'Mario Kart',
    kartDebutYear: 1992,
  );

  static CharacterExtras of(String characterId) =>
      _byId[characterId] ?? fallback;

  static const Map<String, CharacterExtras> _byId = {
    'mario': CharacterExtras(
      racerNumber: 1,
      tagline: 'The benchmark racer',
      bio:
          "Nintendo's mascot is the yardstick every other racer is measured "
          'against. His stats sit in the middle of the pack with nothing to '
          'hide, which makes him a safe choice on any course and with almost '
          'any kart.',
      playstyle:
          'Race clean: take smooth lines, link drift boosts through the bends '
          'and let your kart choice do the specializing.',
      species: 'Human',
      debut: 'Donkey Kong (1981)',
      kartDebut: 'Super Mario Kart',
      kartDebutYear: 1992,
      strengths: [
        'No weak stat to cover for',
        'Pairs well with nearly any kart',
        'Forgiving for first-time racers',
      ],
      weaknesses: [
        'Tops no single stat',
        'Out-accelerated by lightweights and out-muscled by heavyweights',
      ],
      funFacts: [
        'One of the eight racers in the original Super Mario Kart (1992).',
        'Has been a playable racer in every main Mario Kart game.',
      ],
      bestTrackIds: ['moo_moo_meadows', 'royal_raceway'],
    ),
    'luigi': CharacterExtras(
      racerNumber: 2,
      tagline: "Mario's near-twin",
      bio:
          "Mario's younger brother drives almost exactly like him on paper. He "
          'trades a sliver of speed and handling for a little more weight and '
          'grip, which suits steady, patient racers.',
      playstyle:
          'Drive him like Mario, but lean on the extra grip: he is happiest '
          'holding a clean line through long bends.',
      species: 'Human',
      debut: 'Mario Bros. (1983)',
      kartDebut: 'Super Mario Kart',
      kartDebutYear: 1992,
      strengths: [
        'Slightly better grip than Mario',
        'Easy to pair with the Standard Kart',
      ],
      weaknesses: ['A touch slower and less nimble than Mario'],
      funFacts: [
        'One of the eight racers in the original Super Mario Kart (1992).',
        "Mario Bros. Circuit, Mario Kart World's opening course, is his first "
            'themed course since Mario Kart Wii.',
      ],
      bestTrackIds: ['dry_dry_dessert', 'moo_moo_meadows'],
    ),
    'peach': CharacterExtras(
      racerNumber: 3,
      tagline: 'Top-speed specialist',
      bio:
          "The Mushroom Kingdom's princess is the fastest racer in this "
          'roster: the highest top speed, but a light frame and loose grip. '
          'She rewards open roads and clean air.',
      playstyle:
          'Stay out of traffic. Use her top speed on long straights and avoid '
          'bumping, because her light frame loses most shoving matches.',
      species: 'Human',
      debut: 'Super Mario Bros. (1985)',
      kartDebut: 'Super Mario Kart',
      kartDebutYear: 1992,
      strengths: [
        'Highest top speed in the roster',
        'Excellent on long straights',
      ],
      weaknesses: [
        'Light, so she is easily bumped off her line',
        'Below-average grip in corners',
      ],
      funFacts: [
        'One of the eight racers in the original Super Mario Kart (1992).',
        'Royal Raceway circles the grounds of her castle.',
      ],
      bestTrackIds: ['royal_raceway', 'moo_moo_meadows'],
    ),
    'bowser': CharacterExtras(
      racerNumber: 4,
      tagline: 'Heavyweight king',
      bio:
          'The King of the Koopas is by far the heaviest racer here. He is '
          'slow off the line and wide through corners, but once he is rolling '
          'almost nothing can push him off the road.',
      playstyle:
          'Plan every corner early, brake before the turn and use your weight '
          'to shoulder lighter racers aside.',
      species: 'Koopa',
      debut: 'Super Mario Bros. (1985)',
      kartDebut: 'Super Mario Kart',
      kartDebutYear: 1992,
      strengths: [
        'Heaviest racer, so he wins collisions',
        'Decent top speed once up to pace',
      ],
      weaknesses: ['Slowest acceleration', 'Widest, laziest handling'],
      funFacts: [
        'One of the eight racers in the original Super Mario Kart (1992).',
        "Bowser's Castle is one of the Lightning Cup courses in Mario Kart "
            'World.',
      ],
      bestTrackIds: ['dry_dry_dessert', 'royal_raceway'],
    ),
    'yoshi': CharacterExtras(
      racerNumber: 5,
      tagline: 'Corner-carving all-rounder',
      bio:
          'A balanced racer who gets a little more acceleration and handling '
          'than Mario in exchange for a bit of top speed. A strong pick for '
          'courses packed with corners.',
      playstyle:
          'Attack the bends: quick acceleration out of corners means short, '
          'frequent boosts that add up over a lap.',
      species: 'Yoshi',
      debut: 'Super Mario World (1990)',
      kartDebut: 'Super Mario Kart',
      kartDebutYear: 1992,
      strengths: [
        'Quick acceleration for a balanced racer',
        'Handling on par with Mario',
        'Good grip',
      ],
      weaknesses: ['Slightly lower top speed than Mario and Luigi'],
      funFacts: [
        'Debuted in Super Mario World in 1990, two years before joining the '
            'Super Mario Kart roster.',
        'One of the eight racers in the original Super Mario Kart (1992).',
      ],
      bestTrackIds: ['moo_moo_meadows', 'rainbow_road'],
    ),
    'toad': CharacterExtras(
      racerNumber: 6,
      tagline: 'Lightweight launcher',
      bio:
          'The loyal Mushroom Kingdom attendant is the lightest racer here '
          'and the quickest off the line, with sharp handling to match. The '
          'price is the lowest top speed and little weight to hold his ground.',
      playstyle:
          'Win the corners: launch out of every bend, stay off other racers '
          'and keep your line tidy.',
      species: 'Toad',
      debut: 'Super Mario Bros. (1985)',
      kartDebut: 'Super Mario Kart',
      kartDebutYear: 1992,
      strengths: [
        'Best acceleration in the roster',
        'Sharp handling on technical sections',
      ],
      weaknesses: [
        'Lowest top speed',
        'Lightest, so he gets bounced around in traffic',
      ],
      funFacts: [
        'One of the eight racers in the original Super Mario Kart (1992).',
        "Toad's Factory is one of the Lightning Cup courses in Mario Kart "
            'World.',
      ],
      bestTrackIds: ['rainbow_road', 'royal_raceway'],
    ),
  };
}

/// Derived numbers shown on the driver profile.
extension CharacterRating on Character {
  /// Average of the four "performance" stats (weight is a trade-off, not a
  /// score), as a 0-100 number.
  int get overallRating =>
      (((speed + acceleration + handling + traction) / 4) * 100).round();

  /// Label of this racer's highest stat.
  String get topStat {
    final stats = <String, double>{
      'Speed': speed,
      'Acceleration': acceleration,
      'Weight': weight,
      'Handling': handling,
      'Traction': traction,
    };
    var bestLabel = 'Speed';
    var bestValue = -1.0;
    stats.forEach((label, value) {
      if (value > bestValue) {
        bestLabel = label;
        bestValue = value;
      }
    });
    return bestLabel;
  }
}
