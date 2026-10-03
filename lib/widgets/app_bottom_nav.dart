import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The persistent bottom nav shown on Home, Character Guide, Track Guide,
/// and Favorites. Detail screens use a back chevron instead and don't show
/// this widget.
///
/// Character Guide has no dedicated tab of its own (it's reached via the
/// Home category card), so it passes [currentIndex] 0 to keep "Home"
/// highlighted, matching the mockup.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.flag_rounded, label: 'Tracks'),
    (icon: Icons.directions_car_filled_rounded, label: 'Karts'),
    (icon: Icons.star_rounded, label: 'Favorites'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = index == currentIndex;
              final color = selected
                  ? AppColors.primary
                  : AppColors.textTertiary;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, color: color, size: 22),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: color),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
