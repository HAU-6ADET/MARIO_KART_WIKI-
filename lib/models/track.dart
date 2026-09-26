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

  const Track({
    required this.id,
    required this.name,
    required this.cup,
    required this.difficulty,
    required this.tileColor,
    this.shortcuts = const [],
    this.hazards = const [],
    this.strategyTips = const [],
  });
}
