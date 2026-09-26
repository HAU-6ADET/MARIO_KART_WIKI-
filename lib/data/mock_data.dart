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
      imageAsset: 'assets/characters/mario.png'
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
      id: 'rainbow_road',
      name: 'Rainbow Road',
      cup: 'Special Cup',
      difficulty: 'Hard',
      tileColor: AppColors.dataBlue,
      shortcuts: ['Cut across the star-field gap after the first bend'],
      hazards: ['No guardrails on most turns', 'Anti-gravity sections'],
      strategyTips: ['Hug the inside line through anti-gravity turns'],
    ),
    Track(
      id: 'moo_moo_meadows',
      name: 'Moo Moo Meadows',
      cup: 'Flower Cup',
      difficulty: 'Easy',
      tileColor: AppColors.success,
      shortcuts: ['Boost panel through the barn shortcut'],
      hazards: ['Wandering Moo Moos on the track'],
      strategyTips: ['Great track to practice drift-boosting'],
    ),
    Track(
      id: 'dry_bones_burnout',
      name: 'Dry Bones Burnout',
      cup: 'Shell Cup',
      difficulty: 'Medium',
      tileColor: AppColors.secondary,
      shortcuts: ['Jump the bone-pile gap near the midpoint'],
      hazards: ['Dry Bones piles that collapse and respawn'],
      strategyTips: ['Save your mushroom for the final straight'],
    ),
    Track(
      id: 'crown_city',
      name: 'Crown City',
      cup: 'Star Cup',
      difficulty: 'Medium',
      tileColor: AppColors.primary,
      shortcuts: ['Alley cut-through after the plaza turn'],
      hazards: ['Narrow city streets, tight corners'],
      strategyTips: ['Brake earlier than you think into the plaza'],
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
  ];

  static Kart? kartById(String id) {
    for (final k in karts) {
      if (k.id == id) return k;
    }
    return null;
  }
}
