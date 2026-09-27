/// Kart/bike model.
///
/// NOTE: no Karts & Bikes screen was in the mockup handoff (see README
/// "Known issues"). This model and the Kart Guide/Detail screens are a
/// best-effort extrapolation from the Home category card ("Karts & Bikes",
/// 18 vehicles) and the "Best paired with" kart names on Character Detail,
/// built to keep the Karts bottom-nav tab functional. Replace/adjust once a
/// real mockup exists.
class Kart {
  final String id;
  final String name;

  /// 0.0–1.0, matching StatBar's expected range.
  final double speed;
  final double acceleration;
  final double weight;
  final double handling;
  final double traction;

  const Kart({
    required this.id,
    required this.name,
    required this.speed,
    required this.acceleration,
    required this.weight,
    required this.handling,
    required this.traction,
  });
}
