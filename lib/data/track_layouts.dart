import 'dart:ui';

enum MapMarkerType { sector, shortcut, hazard }

class MapMarker {
  /// Position along the lap, 0.0 (start line) to 1.0 (back at the start).
  final double t;
  final MapMarkerType type;
  final String label; // shown for sector markers, e.g. "1"

  const MapMarker(this.t, this.type, [this.label = '']);
}

/// A simplified top-down drawing of a course: a closed loop through
/// [points] (each 0.0-1.0 inside the map box) with a few markers.
///
/// These are schematic layouts that capture each course's general character
/// (long straights, hairpins, winding sections). They are NOT to scale and
/// marker positions are approximate; the map in the app says so.
class TrackLayout {
  final List<Offset> points;
  final List<MapMarker> markers;

  const TrackLayout({required this.points, required this.markers});

  static TrackLayout? of(String trackId) => _byId[trackId];

  static const Map<String, TrackLayout> _byId = {
    'moo_moo_meadows': TrackLayout(
      points: [
        Offset(0.12, 0.55),
        Offset(0.18, 0.25),
        Offset(0.42, 0.14),
        Offset(0.58, 0.32),
        Offset(0.80, 0.18),
        Offset(0.90, 0.50),
        Offset(0.74, 0.80),
        Offset(0.50, 0.68),
        Offset(0.30, 0.86),
      ],
      markers: [
        MapMarker(0.12, MapMarkerType.sector, '1'),
        MapMarker(0.30, MapMarkerType.hazard),
        MapMarker(0.45, MapMarkerType.sector, '2'),
        MapMarker(0.62, MapMarkerType.shortcut),
        MapMarker(0.80, MapMarkerType.sector, '3'),
      ],
    ),
    'dry_dry_dessert': TrackLayout(
      points: [
        Offset(0.10, 0.72),
        Offset(0.10, 0.30),
        Offset(0.30, 0.14),
        Offset(0.70, 0.14),
        Offset(0.90, 0.30),
        Offset(0.86, 0.60),
        Offset(0.62, 0.56),
        Offset(0.50, 0.86),
        Offset(0.26, 0.86),
      ],
      markers: [
        MapMarker(0.10, MapMarkerType.sector, '1'),
        MapMarker(0.25, MapMarkerType.hazard),
        MapMarker(0.45, MapMarkerType.sector, '2'),
        MapMarker(0.60, MapMarkerType.shortcut),
        MapMarker(0.72, MapMarkerType.hazard),
        MapMarker(0.85, MapMarkerType.sector, '3'),
      ],
    ),
    'royal_raceway': TrackLayout(
      points: [
        Offset(0.12, 0.50),
        Offset(0.20, 0.20),
        Offset(0.55, 0.14),
        Offset(0.86, 0.24),
        Offset(0.88, 0.50),
        Offset(0.66, 0.56),
        Offset(0.80, 0.80),
        Offset(0.46, 0.86),
        Offset(0.20, 0.80),
      ],
      markers: [
        MapMarker(0.10, MapMarkerType.sector, '1'),
        MapMarker(0.38, MapMarkerType.sector, '2'),
        MapMarker(0.52, MapMarkerType.hazard),
        MapMarker(0.62, MapMarkerType.shortcut),
        MapMarker(0.82, MapMarkerType.sector, '3'),
      ],
    ),
    'rainbow_road': TrackLayout(
      points: [
        Offset(0.10, 0.80),
        Offset(0.14, 0.40),
        Offset(0.34, 0.18),
        Offset(0.50, 0.44),
        Offset(0.66, 0.18),
        Offset(0.88, 0.30),
        Offset(0.86, 0.66),
        Offset(0.62, 0.86),
        Offset(0.42, 0.66),
        Offset(0.30, 0.90),
      ],
      markers: [
        MapMarker(0.10, MapMarkerType.sector, '1'),
        MapMarker(0.30, MapMarkerType.hazard),
        MapMarker(0.45, MapMarkerType.sector, '2'),
        MapMarker(0.58, MapMarkerType.shortcut),
        MapMarker(0.72, MapMarkerType.hazard),
        MapMarker(0.85, MapMarkerType.sector, '3'),
      ],
    ),
  };
}
