import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The star toggle used on detail-screen headers, list rows, and Favorites.
class FavoriteButton extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback onToggle;
  final double size;

  const FavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onToggle,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
        color: isFavorited ? AppColors.secondary : AppColors.textTertiary,
        size: size,
      ),
      tooltip: isFavorited ? 'Remove from favorites' : 'Add to favorites',
    );
  }
}
