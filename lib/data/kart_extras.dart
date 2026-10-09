import '../models/character.dart';
import '../models/kart.dart';
import 'mock_data.dart';
import 'track_extras.dart';

/// Extra info for each kart/bike, kept apart from the [Kart] model (which
/// only holds the five stats). Looked up by kart id.
///
/// The five stats themselves are this wiki's own estimates (see
/// lib/models/kart.dart), so everything computed from them below (overall,
/// ranks, strongest / weakest stat) is an estimate too.
class KartExtras {
  final String type; // "Kart" or "Bike"
  final String tagline;
  final String overview;
  final List<String> highlights;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> tips;
  final String bestFor;

  const KartExtras({
    required this.type,
    required this.tagline,
    required this.overview,
    required this.bestFor,
    this.highlights = const [],
    this.strengths = const [],
    this.weaknesses = const [],
    this.tips = const [],
  });

  bool get isBike => type == 'Bike';

  static const KartExtras fallback = KartExtras(
    type: 'Kart',
    tagline: 'A vehicle for the grid',
    overview: 'Details for this vehicle are coming soon.',
    bestFor: 'Anyone',
  );

  static KartExtras of(String kartId) => _byId[kartId] ?? fallback;

  static const Map<String, KartExtras> _byId = {
    'standard_kart': KartExtras(
      type: 'Kart',
      tagline: 'The dependable all-rounder',
      overview:
          'Balanced across the board, with handling as its best stat. A safe '
          'pick when you are still learning a course.',
      bestFor: 'New drivers and anyone who wants no surprises.',
      highlights: ['Balanced', 'Beginner friendly', 'Steady handling'],
      strengths: [
        'Handling is its best stat',
        'No stat is a real weak spot',
      ],
      weaknesses: [
        'Does not lead the garage in any stat',
        'Top speed is only average',
      ],
      tips: [
        'Pair it with a fast or heavy racer to add what it lacks',
        'A good first choice on an easy course like Moo Moo Meadows',
      ],
    ),
    'mach_rocket': KartExtras(
      type: 'Kart',
      tagline: 'Built for top speed',
      overview:
          'Top speed is its calling card, but acceleration and handling are '
          'only middling, so it rewards long straights and clean lines.',
      bestFor: 'Confident drivers on courses with long straights.',
      highlights: ['Top speed', 'Long straights', 'Needs a steady hand'],
      strengths: [
        'Excellent top speed',
        'Pulls away on long, open roads',
      ],
      weaknesses: [
        'Handling is its lowest stat',
        'Slow to get back up to speed after a hit',
      ],
      tips: [
        'Brake and drift early because it does not turn sharply',
        'Suits the long straights of Royal Raceway',
      ],
    ),
    'Yoshi Bike': KartExtras(
      type: 'Bike',
      tagline: 'A quick, grippy bike',
      overview:
          'A well-rounded bike with good top speed and solid grip. Handling is '
          'its softer side, so plan your turns early.',
      bestFor: 'Drivers who like a quick bike that is easy to keep on the road.',
      highlights: ['Bike', 'Good grip', 'Quick'],
      strengths: [
        'Good top speed',
        'Solid grip and acceleration',
      ],
      weaknesses: [
        'Handling is its lowest stat',
        'Not the heaviest, so rivals can bump you around',
      ],
      tips: [
        'Take wide, early lines through corners',
        'Use the grip on mixed surfaces such as grass and dirt',
      ],
    ),
    'MR.Soooby': KartExtras(
      type: 'Kart',
      tagline: 'The custom all-star',
      overview:
          'A custom build that leads the garage in acceleration and grip '
          'while keeping top-tier speed. Handling is its only soft spot.',
      bestFor: 'Aggressive drivers who want to recover fast after every hit.',
      highlights: ['Best acceleration', 'Top-tier speed', 'Strong grip'],
      strengths: [
        'Highest acceleration in the garage',
        'Excellent grip, so sand and grass cost less speed',
        'Top-end speed to match',
      ],
      weaknesses: [
        'Handling is its weakest stat',
        'Tight hairpins take care',
      ],
      tips: [
        'Brake early for hairpins, then use the acceleration to rebound',
        'A strong pick for sandy courses like Dry Dry Desert',
      ],
    ),
  };
}

// ---------------------------------------------------------------------------
// Stat helpers shared by the kart screens
// ---------------------------------------------------------------------------

double kartStat(Kart k, TrackFocus f) {
  switch (f) {
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

double racerStat(Character c, TrackFocus f) {
  switch (f) {
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

/// Stats where higher is simply better (weight is a play-style choice).
const List<TrackFocus> kartPerformanceStats = [
  TrackFocus.speed,
  TrackFocus.acceleration,
  TrackFocus.handling,
  TrackFocus.traction,
];

int kartOverall(Kart k) =>
    ((k.speed + k.acceleration + k.weight + k.handling + k.traction) /
            5 *
            100)
        .round();

TrackFocus kartTopStat(Kart k) {
  var best = kartPerformanceStats.first;
  for (final f in kartPerformanceStats) {
    if (kartStat(k, f) > kartStat(k, best)) best = f;
  }
  return best;
}

/// Lowest performance stat, or null when the kart is evenly balanced.
TrackFocus? kartWeakStat(Kart k) {
  var low = kartPerformanceStats.first;
  var high = kartPerformanceStats.first;
  for (final f in kartPerformanceStats) {
    if (kartStat(k, f) < kartStat(k, low)) low = f;
    if (kartStat(k, f) > kartStat(k, high)) high = f;
  }
  return kartStat(k, high) - kartStat(k, low) >= 0.1 ? low : null;
}

String kartWeightClass(Kart k) {
  if (k.weight < 0.5) return 'Light';
  if (k.weight < 0.65) return 'Medium';
  return 'Heavy';
}

/// 1 = best in the garage for this stat.
int kartRank(Kart k, TrackFocus f) =>
    1 + MockData.karts.where((o) => kartStat(o, f) > kartStat(k, f)).length;

double garageAverage(TrackFocus f) =>
    MockData.karts.fold<double>(0, (sum, k) => sum + kartStat(k, f)) /
    MockData.karts.length;
