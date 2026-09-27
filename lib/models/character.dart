import 'package:flutter/material.dart';

enum CharacterClass { speed, balanced, heavy, lightweight }

extension CharacterClassLabel on CharacterClass {
  String get label {
    switch (this) {
      case CharacterClass.speed:
        return 'Speed';
      case CharacterClass.balanced:
        return 'Balanced';
      case CharacterClass.heavy:
        return 'Heavy';
      case CharacterClass.lightweight:
        return 'Lightweight';
    }
  }
}

class Character {
  final String id;
  final String name;
  final String initials;
  final Color avatarColor;
  final CharacterClass characterClass;
  final String subtitle; // e.g. "All-Round Racer"
  final bool unlocked;
  final String unlockTitle; // e.g. "Available from the start"
  final String unlockDescription; // e.g. "No unlock requirement"

  /// Optional asset path for a face image, e.g. 'assets/characters/mario.png'.
  ///
  /// No image files ship with this project — see assets/characters/README.md.
  /// When this is null (the default), every avatar falls back to the
  /// colored initials circle automatically; nothing needs to change in the
  /// UI code to "turn on" images later, just add the file and set this path.
  final String? imageAsset;

  /// 0.0–1.0, matching StatBar's expected range.
  final double speed;
  final double acceleration;
  final double weight;
  final double handling;
  final double traction;

  /// Names of karts this character is "Best paired with".
  final List<String> bestPairedWithKartIds;

  const Character({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.characterClass,
    required this.subtitle,
    required this.unlocked,
    required this.unlockTitle,
    required this.unlockDescription,
    required this.speed,
    required this.acceleration,
    required this.weight,
    required this.handling,
    required this.traction,
    this.bestPairedWithKartIds = const [],
    this.imageAsset,
  });
}
