import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A single labeled stat row: "Speed  [====------]".
///
/// [value] is 0.0–1.0.
class StatBar extends StatelessWidget {
  final String label;
  final double value;

  const StatBar({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: clamped,
                minHeight: 10,
                backgroundColor: AppColors.surfaceHigh,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
