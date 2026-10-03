import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Race-flag colors for a difficulty: green = easy, yellow = medium,
/// red = hard.
Color racingDifficultyColor(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return AppColors.success;
    case 'hard':
      return AppColors.primary;
    case 'medium':
    default:
      return AppColors.secondary;
  }
}

int _flagCount(String difficulty) {
  switch (difficulty.toLowerCase()) {
    case 'easy':
      return 1;
    case 'hard':
      return 3;
    case 'medium':
    default:
      return 2;
  }
}

/// Difficulty shown as 1-3 race flags (colored flags = difficulty level).
class DifficultyFlags extends StatelessWidget {
  final String difficulty;
  final double size;

  const DifficultyFlags({super.key, required this.difficulty, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final color = racingDifficultyColor(difficulty);
    final count = _flagCount(difficulty);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Icon(
            Icons.flag_rounded,
            size: size,
            color: i < count ? color : AppColors.textTertiary,
          ),
      ],
    );
  }
}
