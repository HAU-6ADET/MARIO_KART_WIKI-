import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// A small circular badge: a green check when unlocked, a muted lock icon
/// when not. Status only — never tappable.
class UnlockStatusIcon extends StatelessWidget {
  final bool unlocked;

  const UnlockStatusIcon({super.key, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    if (unlocked) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.success,
        ),
        child: const Icon(Icons.check, size: 18, color: Colors.white),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceHigh,
      ),
      child: const Icon(Icons.lock_outline, size: 16, color: AppColors.textTertiary),
    );
  }
}
