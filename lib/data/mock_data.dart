import 'package:flutter/material.dart';

import '../models/character.dart';
import '../models/kart.dart';
import '../models/track.dart';
import '../theme/theme.dart';

/// All data below is bundled locally — there is no backend. Values for the
/// six characters and four tracks come directly from mockup.pdf. Karts data
/// is extrapolated (see lib/models/kart.dart) since no Kart mockup exists.
class MockData {
  MockData._();

  static const List<Character> characters = [
    Character(
      id: 'mario',
      name: 'Mario',
      initials: 'MR',
      imageAsset: 'assets/characters/Mario.png',
      avatarColor: Color(0xFFE84A3B),
      characterClass: CharacterClass.balanced,
      subtitle: 'All-Round Racer',
      unlocked: true,
      unlockTitle: 'Available from the start',
      unlockDescription: 'No unlock requirement',
      speed: 0.7,
      acceleration: 0.65,
      weight: 0.55,
      handling: 0.7,
      traction: 0.6,
      bestPairedWithKartIds: ['standard_kart', 'mach_rocket'],
    ),
    Character(
      id: 'luigi',
      name: 'Luigi',
      initials: 'LG',
      imageAsset: 'assets/characters/luigi.png',
      avatarColor: Color(0xFF3BA95A),
      characterClass: CharacterClass.balanced,
      subtitle: 'All-Round Racer',
      unlocked: true,
      unlockTitle: 'Available from the start',
      unlockDescription: 'No unlock requirement',
      speed: 0.68,
      acceleration: 0.66,
      weight: 0.56,
      handling: 0.68,
      traction: 0.62,
      bestPairedWithKartIds: ['standard_kart'],
    ),
    Character(
      id: 'peach',
      name: 'Peach',
      initials: 'PC',
      imageAsset: 'assets/characters/peach.png',
      avatarColor: Color(0xFFF178A6),
      characterClass: CharacterClass.speed,
      subtitle: 'Speed Specialist',
      unlocked: true,
      unlockTitle: 'Available from the start',
      unlockDescription: 'No unlock requirement',
      speed: 0.85,
      acceleration: 0.6,
      weight: 0.4,
      handling: 0.55,
      traction: 0.5,
      bestPairedWithKartIds: ['mach_rocket'],
    ),
    Character(
      id: 'bowser',
      name: 'Bowser',
      initials: 'BW',
      imageAsset: 'assets/characters/bowser.png',
      avatarColor: Color(0xFFE8952B),
      characterClass: CharacterClass.heavy,
      subtitle: 'Heavyweight Bruiser',
      unlocked: true,
      unlockTitle: 'Available from the start',
      unlockDescription: 'No unlock requirement',
      speed: 0.6,
      acceleration: 0.4,
      weight: 0.95,
      handling: 0.35,
      traction: 0.5,
      bestPairedWithKartIds: ['standard_kart'],
    ),
    Character(
      id: 'yoshi',
      name: 'Yoshi',
      initials: 'YS',
      imageAsset: 'assets/characters/yoshi.png',
      avatarColor: Color(0xFF4CC24A),
      characterClass: CharacterClass.balanced,
      subtitle: 'All-Round Racer',
      unlocked: true,
      unlockTitle: 'Available from the start',
      unlockDescription: 'No unlock requirement',
      speed: 0.66,
      acceleration: 0.68,
      weight: 0.5,
      handling: 0.7,
      traction: 0.65,
      bestPairedWithKartIds: ['standard_kart'],
    ),
    Character(
      id: 'toad',
      name: 'Toad',
      initials: 'TD',
      imageAsset: 'assets/characters/toad.png',
      avatarColor: Color(0xFFE8536B),
      characterClass: CharacterClass.lightweight,
      subtitle: 'Nimble Lightweight',
      unlocked: false,
      unlockTitle: 'Locked',
      unlockDescription: 'Win the Flower Cup on 100cc to unlock',
      speed: 0.5,
      acceleration: 0.85,
      weight: 0.25,
      handling: 0.8,
      traction: 0.55,
      bestPairedWithKartIds: ['mach_rocket'],
    ),
  ];

  static const List<Track> tracks = [
    Track(
      id: 'moo_moo_meadows',
      name: 'Moo Moo Meadows',
      imageAsset: 'assets/tracks/moo_moo_meadow.png',
      cup: 'Shell Cup',
      difficulty: 'Easy',
      tileColor: AppColors.success,
      shortcuts: [
        'Boost with a Mushroom across the grass on the sharper bends to skip the corner',
      ],
      hazards: [
        'Cows wandering across the track',
        'Moles that pop out of the ground in your path',
      ],
      strategyTips: [
        'Long, easy curves make this the best course to practise drift mini-turbos',
        'Stay on the road between the cows rather than swerving into the grass',
      ],
    ),
    Track(
      id: 'dry_dry_dessert',
      name: 'Dry Dry Desert',
      imageAsset: 'assets/tracks/dry_dry_dessert.png',
      cup: 'Banana Cup',
      difficulty: 'Medium',
      tileColor: AppColors.secondary,
      shortcuts: ['Use a Mushroom to cut through the sand on wide corners'],
      hazards: [
        'Loose sand off the road slows your kart',
        'Quicksand pits that swallow karts',
        'Stone pillars and ruins that narrow the road',
      ],
      strategyTips: [
        'Keep to the packed road and only leave it with a boost in hand',
        'Save a Mushroom for the final straight of the last lap',
      ],
    ),
    Track(
      id: 'royal_raceway',
      name: 'Royal Raceway',
      imageAsset: 'assets/tracks/royal_raceway.png',
      cup: 'Banana Cup',
      difficulty: 'Medium',
      tileColor: AppColors.primary,
      shortcuts: [
        'Look for ramps and gaps along the track to skip sections with a boost',
      ],
      hazards: [
        'A wide road lets rivals box you in on the opening straight',
        'Sharp bends where speed built up on the straights is easy to lose',
      ],
      strategyTips: [
        'Brake and drift early into the tight bends, then boost out of them',
        'Hold the inside line to keep rivals from passing on the exit',
      ],
    ),
    Track(
      id: 'rainbow_road',
      name: 'Rainbow Road',
      imageAsset: 'assets/tracks/rainbow_road.png',
      cup: 'Special Cup',
      difficulty: 'Hard',
      tileColor: AppColors.dataBlue,
      shortcuts: [
        'On the descent, look for the Special Cup sign and fly across with a Mushroom to skip a long stretch (risky: a miss means falling off)',
      ],
      hazards: [
        'Open edges and long drops',
        'Anti-gravity sections that change how the kart handles',
      ],
      strategyTips: [
        'Bump into rivals while in anti-gravity to earn a spin boost',
        'Hug the inside line through the curves and avoid the edge',
      ],
    ),
  ];

  // Extrapolated — see lib/models/kart.dart.
  static const List<Kart> karts = [
    Kart(
      id: 'standard_kart',
      name: 'Standard Kart',
      speed: 0.55,
      acceleration: 0.55,
      weight: 0.55,
      handling: 0.6,
      traction: 0.55,
    ),
    Kart(
      id: 'mach_rocket',
      name: 'Mach Rocket',
      speed: 0.85,
      acceleration: 0.5,
      weight: 0.5,
      handling: 0.45,
      traction: 0.5,
    ),
    Kart(
      id: 'Yoshi Bike',
      name: 'Yoshi Bike',
      speed: 0.7,
      acceleration: 0.6,
      weight: 0.6,
      handling: 0.5,
      traction: 0.6,
    ),
    Kart(
      id: 'MR.Soooby',
      name: 'MR.Soooby',
      speed: 0.85,
      acceleration: 0.9,
      weight: 0.7,
      handling: 0.56,
      traction: 0.8,
    ),
  ];

  static Kart? kartById(String id) {
    for (final k in karts) {
      if (k.id == id) return k;
    }
    return null;
  }
}
