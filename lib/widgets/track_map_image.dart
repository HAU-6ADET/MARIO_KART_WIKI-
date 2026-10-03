import 'package:flutter/material.dart';

/// A rounded-rect track map/course image that shows [imageAsset] when it's
/// set and loads successfully, and otherwise falls back to a colored tile
/// with a flag icon — no crash, no broken-image icon, just a silent
/// fallback. Mirrors CharacterAvatar's pattern for characters.
///
/// This is what every track map appears from in the app (list rows and the
/// Track Detail header), so dropping a real image into assets/tracks/ and
/// setting `imageAsset` on a Track in mock_data.dart is the only change
/// needed to switch a track over from the flag-tile fallback to a real map.
///
/// Perf: [width]/[height] are passed through to Image.asset's `cacheWidth`
/// / `cacheHeight` (scaled for device pixel ratio), so the image is decoded
/// once at the size it's actually displayed at instead of full resolution.
/// That matters here specifically because the same asset is shown small in
/// list rows and large in the detail header — without this, a big source
/// PNG would be decoded at full size for every row in a scrolled list.
class TrackMapImage extends StatelessWidget {
  final String? imageAsset;
  final Color fallbackColor;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final double flagIconSize;

  const TrackMapImage({
    super.key,
    required this.fallbackColor,
    required this.width,
    required this.height,
    this.imageAsset,
    this.borderRadius = BorderRadius.zero,
    this.flagIconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    if (imageAsset != null) {
      final dpr = MediaQuery.devicePixelRatioOf(context);
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          imageAsset!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          // Decode at display resolution rather than the source file's
          // full resolution — cuts memory and CPU cost per image, which
          // adds up fast across a scrolling list of tracks.
          cacheWidth: (width * dpr).round(),
          cacheHeight: (height * dpr).round(),
          // Missing asset, or declared but not yet added to pubspec.yaml
          // -> fall back to the flag tile instead of a broken-image icon.
          errorBuilder: (context, error, stackTrace) => _flagTile(),
        ),
      );
    }
    return ClipRRect(borderRadius: borderRadius, child: _flagTile());
  }

  Widget _flagTile() {
    return Container(
      width: width,
      height: height,
      color: fallbackColor,
      alignment: Alignment.center,
      child: Icon(
        Icons.flag_rounded,
        color: Colors.black87,
        size: flagIconSize,
      ),
    );
  }
}
