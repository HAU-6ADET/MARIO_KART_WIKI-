import 'package:flutter/material.dart';

/// A circular avatar that shows [imageAsset] when it's set and loads
/// successfully, and otherwise falls back to a colored circle with
/// [initials] — no crash, no broken-image icon, just a silent fallback.
///
/// This is what every character avatar in the app (list rows, "recently
/// viewed", the Character Detail header) is built from, so dropping a real
/// image file into assets/characters/ and setting `imageAsset` on a
/// Character in mock_data.dart is the only change needed to switch that
/// character over from initials to a face image.
class CharacterAvatar extends StatelessWidget {
  final String? imageAsset;
  final String initials;
  final Color color;
  final double radius;

  const CharacterAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.imageAsset,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final diameter = radius * 2;

    if (imageAsset != null) {
      return ClipOval(
        child: Image.asset(
          imageAsset!,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          // If the asset is missing, or hasn't been declared in pubspec.yaml
          // yet, fall back to the initials circle instead of crashing or
          // showing Flutter's broken-image placeholder.
          errorBuilder: (context, error, stackTrace) => _initialsCircle(context),
        ),
      );
    }
    return _initialsCircle(context);
  }

  Widget _initialsCircle(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.5,
        ),
      ),
    );
  }
}
