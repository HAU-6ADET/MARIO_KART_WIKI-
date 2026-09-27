import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'character_avatar.dart';

/// The shared row used on Character Guide (name + class chip + unlock icon)
/// and Favorites (name + type label + star). [subtitle] is rendered as a
/// small pill so it reads as a chip either way.
class EntityListTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final Color avatarColor;
  final String initials;
  final String? imageAsset;
  final Widget? trailing;
  final VoidCallback? onTap;

  const EntityListTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatarColor,
    required this.initials,
    this.imageAsset,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CharacterAvatar(
                initials: initials,
                color: avatarColor,
                imageAsset: imageAsset,
                radius: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
