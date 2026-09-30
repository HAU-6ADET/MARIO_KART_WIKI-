import 'package:flutter/material.dart';

class Track {
  final String id;
  final String name;
  final String cup; // e.g. "Special Cup"
  final String difficulty; // "Easy" | "Medium" | "Hard"
  final Color tileColor;

  /// Extrapolated content for Track Detail — no track-detail mockup exists
  /// yet, only the caption on mockup.pdf's overview page ("shortcuts,
  /// hazards, strategy — same pattern as Character Detail"). Treat these as
  /// placeholders to replace once that screen is actually designed.
  final List<String> shortcuts;
  final List<String> hazards;
  final List<String> strategyTips;

  /// Optional asset path for a top-down map/course image, e.g.
  /// 'assets/tracks/rainbow_road.png'.
  ///
  /// Mirrors Character.imageAsset: no image files ship with this project —
  /// see assets/tracks/README.md. When this is null (the default), the
  /// track's flag-icon tile color is used as the fallback everywhere a map
  /// image would appear, so nothing in the UI needs to change to "turn on"
  /// images later — just add the file and set this path.
  final String? imageAsset;

  const Track({
    required this.id,
    required this.name,
    required this.cup,
    required this.difficulty,
    required this.tileColor,
    this.shortcuts = const [],
    this.hazards = const [],
    this.strategyTips = const [],
    this.imageAsset,
  });
}
