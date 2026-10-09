/// Which stat matters most on a course. Used to pick the racers and karts
/// recommended for it.
enum TrackFocus { speed, acceleration, weight, handling, traction }

extension TrackFocusLabel on TrackFocus {
  String get label {
    switch (this) {
      case TrackFocus.speed:
        return 'Speed';
      case TrackFocus.acceleration:
        return 'Acceleration';
      case TrackFocus.weight:
        return 'Weight';
      case TrackFocus.handling:
        return 'Handling';
      case TrackFocus.traction:
        return 'Traction';
    }
  }
}

/// Extra racing facts for each track, kept separate from the core [Track]
/// model so that model stays unchanged. Looked up by track id.
///
/// Cup, race order, lineup and debut are for the Mario Kart 8 Deluxe version
/// of each course, matching the screenshots in assets/tracks/. The course
/// profile bars (straights, corners, ...) and the challenge rating are
/// editorial estimates written for this wiki, not official game stats.
class TrackExtras {
  final String overview;
  final int raceNumber; // position inside its cup (1-4)
  final String origin; // game the course first appeared in
  final int debutYear;
  final String setting;
  final int laps;

  /// One-line hook shown under the track name.
  final String tagline;

  /// 0-100 editorial difficulty score, shown on the challenge gauge.
  final int challenge;

  /// Short tags such as "Anti-gravity", shown as chips.
  final List<String> highlights;

  /// Course profile, 0.0-1.0 each (editorial estimates).
  final double straights;
  final double corners;
  final double offRoad;
  final double hazardLevel;
  final double shortcutPotential;

  /// The stat that helps most here, and why.
  final TrackFocus focus;
  final String focusReason;

  /// Advice for lap 1, 2 and 3.
  final List<String> lapPlan;
  final List<String> itemTips;
  final List<String> funFacts;

  /// The four courses of this cup in race order (Mario Kart 8 Deluxe).
  final List<String> cupLineup;

  /// Look and feel, taken from the course screenshots.
  final String timeOfDay;
  final String surface;

  /// What happens in sector 1, 2 and 3 (matches the numbers on the map).
  final List<String> sectors;

  /// One tip each for beginner, intermediate and expert drivers.
  final List<String> skillTips;

  /// Common ways to lose time or the race here.
  final List<String> mistakes;

  const TrackExtras({
    required this.overview,
    required this.raceNumber,
    required this.origin,
    required this.setting,
    this.debutYear = 0,
    this.laps = 3,
    this.tagline = '',
    this.challenge = 50,
    this.highlights = const [],
    this.straights = 0.5,
    this.corners = 0.5,
    this.offRoad = 0.5,
    this.hazardLevel = 0.5,
    this.shortcutPotential = 0.5,
    this.focus = TrackFocus.speed,
    this.focusReason = '',
    this.lapPlan = const [],
    this.itemTips = const [],
    this.funFacts = const [],
    this.cupLineup = const [],
    this.timeOfDay = '',
    this.surface = '',
    this.sectors = const [],
    this.skillTips = const [],
    this.mistakes = const [],
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
      timeOfDay: 'Sunset',
      surface: 'Road, grass & dirt',
      sectors: [
        'Wide start straight and first bends. Easy to pick a line and settle into the race.',
        'The farm fields. Cows and moles cross here, so stay central and brake gently.',
        'The windmill run to the line. Long curves are ideal for chaining drifts.',
      ],
      skillTips: [
        'Stay on the road and let the cows pass; a clean lap beats a risky one.',
        'Link drifts through the long bends and use Mushrooms on the grass cuts.',
        'Time boosts out of every bend and take the grass shortcuts without losing speed.',
      ],
      mistakes: [
        'Swerving into the grass after a cow instead of braking gently',
        'Spending Mushrooms on the straights',
      ],
      overview:
          'A sunny farmland circuit with windmills, wide grassy bends and cows '
          'that wander onto the road. Short weaving turns make it a gentle '
          'first race.',
      raceNumber: 1,
      origin: 'Mario Kart Wii',
      debutYear: 2008,
      setting: 'Countryside',
      tagline: 'A friendly farm warm-up',
      challenge: 30,
      highlights: ['Farm hazards', 'Wide corners', 'Beginner friendly'],
      straights: 0.6,
      corners: 0.3,
      offRoad: 0.35,
      hazardLevel: 0.4,
      shortcutPotential: 0.35,
      focus: TrackFocus.acceleration,
      focusReason:
          'Quick acceleration gets you back up to speed after dodging a cow '
          'or a mole.',
      lapPlan: [
        'Learn where the cows cross and hold the middle of the road. Use '
            'this lap to line up your drifts.',
        'Take the sharper bends tight and chain mini-turbos through the '
            'long curves.',
        'Spend every stored item and keep a clean line to the finish.',
      ],
      itemTips: [
        'Use Mushrooms on the bends where you can cut across the grass, not on straights',
        'Drop a Banana on the road after a bend to slow anyone chasing you',
      ],
      funFacts: [
        'Debuted in Mario Kart Wii (2008)',
        'The wandering cows are the course\'s signature moving obstacle',
        'Race 1 of the Shell Cup in Mario Kart 8 Deluxe',
      ],
      cupLineup: [
        'Moo Moo Meadows',
        'Mario Circuit',
        'Cheep Cheep Beach',
        "Toad's Turnpike",
      ],
    ),
    'dry_dry_dessert': TrackExtras(
      timeOfDay: 'Daytime',
      surface: 'Road & sand',
      sectors: [
        'The sphinx gate start. The pack bunches up, so protect your line.',
        'The sand stretch. Quicksand and slow sand punish anyone who drifts wide.',
        'The ruins and pillars. The road narrows, so save a boost for the final straight.',
      ],
      skillTips: [
        'Keep to the packed road and avoid the sand until you are comfortable.',
        'Learn where the quicksand is and cross sand on wide corners only with a boost.',
        'Plan every lap around your boosts so the sand shortcuts never cost you speed.',
      ],
      mistakes: [
        'Drifting wide into the sand without a Mushroom ready',
        'Clipping the pillars while fighting for the inside line',
      ],
      overview:
          'A sun-baked desert run that starts between two giant sphinx '
          'statues. Soft sand lines the road and ruined pillars narrow the '
          'racing line.',
      raceNumber: 1,
      origin: 'Mario Kart: Double Dash!!',
      debutYear: 2003,
      setting: 'Desert',
      tagline: 'Sand, sphinxes and slowdowns',
      challenge: 55,
      highlights: ['Sand slowdowns', 'Quicksand', 'Long straights'],
      straights: 0.7,
      corners: 0.45,
      offRoad: 0.8,
      hazardLevel: 0.65,
      shortcutPotential: 0.5,
      focus: TrackFocus.traction,
      focusReason:
          'Strong traction stops the sand from robbing you of speed when you '
          'drift wide.',
      lapPlan: [
        'Stay on the packed road and learn where the quicksand sits.',
        'Cut wide corners through the sand only when a Mushroom is ready.',
        'Save a boost for the last straight and steer clear of the pillars.',
      ],
      itemTips: [
        'Keep a Mushroom in hand so a trip into the sand never costs you the lead',
        'Use defensive items against rivals bunched up on the narrow stretches',
      ],
      funFacts: [
        'Originally from Mario Kart: Double Dash!! on GameCube (2003)',
        'The start line sits between two giant sphinx statues',
        'Race 1 of the Banana Cup in Mario Kart 8 Deluxe',
      ],
      cupLineup: [
        'Dry Dry Desert',
        'Donut Plains 3',
        'Royal Raceway',
        'DK Jungle',
      ],
    ),
    'royal_raceway': TrackExtras(
      timeOfDay: 'Afternoon',
      surface: 'Tarmac',
      sectors: [
        'The opening straight. The road is wide, so claim your line before the first bend.',
        'The stadium bends. Tight corners arrive right after long, fast straights.',
        'The lakeside run and final bend. Most overtakes happen here.',
      ],
      skillTips: [
        'Follow the road and brake early before the sharp bends.',
        'Drift into each bend, boost out, and hold the inside line.',
        'Look for ramps and gaps where a boost can skip a section.',
      ],
      mistakes: [
        'Carrying too much speed into the sharp bends',
        'Getting boxed in on the wide opening straight',
      ],
      overview:
          "A classic grand-prix circuit around Peach's castle grounds, with a "
          'big grandstand, a lake and a wide road that rewards a clean '
          'racing line.',
      raceNumber: 3,
      origin: 'Mario Kart 64',
      debutYear: 1996,
      setting: 'Castle Grounds',
      tagline: 'A castle-grounds classic',
      challenge: 50,
      highlights: ['Wide road', 'Sharp bends', 'N64 classic'],
      straights: 0.75,
      corners: 0.55,
      offRoad: 0.3,
      hazardLevel: 0.3,
      shortcutPotential: 0.45,
      focus: TrackFocus.handling,
      focusReason:
          'Good handling carries your speed through the tight bends that '
          'follow the long straights.',
      lapPlan: [
        'The road is wide, so pick a line early and avoid being boxed in on '
            'the opening straight.',
        'Brake and drift early into the tight bends, then boost out of them.',
        'Hold the inside line to stop rivals passing on the exit.',
      ],
      itemTips: [
        'Look for ramps and gaps where a boost can skip a section of track',
        'Keep an item for the last bend, where most overtakes happen',
      ],
      funFacts: [
        'Debuted in Mario Kart 64 (1996) on Nintendo 64',
        "Set in the grounds of Princess Peach's castle",
        'Race 3 of the Banana Cup in Mario Kart 8 Deluxe',
      ],
      cupLineup: [
        'Dry Dry Desert',
        'Donut Plains 3',
        'Royal Raceway',
        'DK Jungle',
      ],
    ),
    'rainbow_road': TrackExtras(
      timeOfDay: 'Night',
      surface: 'Glowing road',
      sectors: [
        'The launch and first curves. Learn where the edges are before you push.',
        'The anti-gravity stretch. Bump rivals for spin boosts and hug the inside line.',
        'The descent and final run. The Special Cup sign marks the risky shortcut.',
      ],
      skillTips: [
        'Slow down on the curves and keep away from the edges; finishing matters most.',
        'Use anti-gravity bumps for spin boosts and learn the edges lap by lap.',
        'Chain boosts through the curves and risk the shortcut only when you are ahead.',
      ],
      mistakes: [
        'Cutting corners too tight near the open edges',
        'Attempting the shortcut without a Mushroom or a lead',
      ],
      overview:
          'The Special Cup finale: a glowing night-sky course with '
          'anti-gravity sections and long drops, where one mistake can send '
          'you off the edge.',
      raceNumber: 4,
      origin: 'Mario Kart 8',
      debutYear: 2014,
      setting: 'Sky / Space',
      tagline: 'The ultimate finale',
      challenge: 90,
      highlights: ['Anti-gravity', 'Open edges', 'Risky shortcut'],
      straights: 0.55,
      corners: 0.9,
      offRoad: 0.1,
      hazardLevel: 0.9,
      shortcutPotential: 0.7,
      focus: TrackFocus.handling,
      focusReason:
          'Precise handling keeps you on the road through the curves and '
          'away from the edge.',
      lapPlan: [
        'Play it safe: learn the curves and where the edges are.',
        'Bump rivals in anti-gravity for spin boosts and hug the inside line.',
        'Only attempt the Mushroom shortcut if you are far enough ahead to '
            'risk a fall.',
      ],
      itemTips: [
        'Save a Mushroom for the shortcut near the Special Cup sign on the descent',
        'Defensive items are worth holding: one hit near an edge can cost the race',
      ],
      funFacts: [
        'Rainbow Road is the series\' traditional final course, going back to Super Mario Kart (1992)',
        'This version debuted in Mario Kart 8 (2014) and adds anti-gravity sections',
        'The last race of the Special Cup in Mario Kart 8 Deluxe',
      ],
      cupLineup: [
        'Cloudtop Cruise',
        'Bone-Dry Dunes',
        "Bowser's Castle",
        'Rainbow Road',
      ],
    ),
  };
}
