import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A single labeled stat row: "Speed  [====------]  70".
///
/// [value] is 0.0-1.0. The bar fills in with a short animation, the number
/// on the right is the value out of 100, and an optional [note] (for example
/// a roster rank like "#2") sits at the far end.
class StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String? note;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    this.color = AppColors.primary,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final clamped = value.clamp(0.0, 1.0).toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(label, style: textTheme.bodyMedium),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: clamped),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, animated, _) => LinearProgressIndicator(
                  value: animated,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceHigh,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 26,
            child: Text(
              '${(clamped * 100).round()}',
              textAlign: TextAlign.right,
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
          if (note != null) ...[
            const SizedBox(width: AppSpacing.xs),
            SizedBox(
              width: 26,
              child: Text(
                note!,
                textAlign: TextAlign.right,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
