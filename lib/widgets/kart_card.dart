import 'package:flutter/material.dart';

import '../data/kart_extras.dart';
import '../models/kart.dart';
import '../theme/theme.dart';

/// Garage-style card for the Karts & Bikes list: a blue portrait panel with
/// the vehicle icon, name, type, tagline, overall score and three mini
/// stats (speed / acceleration / handling).
class KartCard extends StatelessWidget {
  final Kart kart;
  final VoidCallback onTap;

  const KartCard({super.key, required this.kart, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final extras = KartExtras.of(kart.id);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 112,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 98,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.dataBlue,
                      AppColors.dataBlue.withValues(alpha: 0.45),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    extras.isBike
                        ? Icons.two_wheeler_rounded
                        : Icons.directions_car_filled_rounded,
                    size: 32,
                    color: AppColors.dataBlue,
                  ),
                ),
              ),
              Container(width: 3, color: AppColors.secondary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md - 2,
                    vertical: AppSpacing.md - 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              kart.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Text(
                            'OVR ${kartOverall(kart)}',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${extras.type} · ${extras.tagline}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(child: _MiniStat('SPD', kart.speed)),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: _MiniStat('ACC', kart.acceleration)),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: _MiniStat('HND', kart.handling)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final double value;

  const _MiniStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 9,
            letterSpacing: 0.6,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            children: [
              Container(height: 5, color: AppColors.surfaceHigh),
              FractionallySizedBox(
                widthFactor: clamped,
                child: Container(
                  height: 5,
                  color: Color.lerp(
                    AppColors.dataBlue,
                    AppColors.primary,
                    clamped,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
