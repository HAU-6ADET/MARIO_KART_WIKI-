import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

import '../data/app_state.dart';
import '../data/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/stat_bar.dart';

/// NOTE: extrapolated — no Kart Detail mockup exists. Mirrors Character
/// Detail's stats layout since design-system.pdf lists StatBar as appearing
/// on Kart Detail too.
class KartDetailScreen extends StatelessWidget {
  final String kartId;

  const KartDetailScreen({super.key, required this.kartId});

  @override
  Widget build(BuildContext context) {
    final kart = MockData.karts.firstWhere((k) => k.id == kartId);
    final appState = AppStateScope.of(context);
    final isFavorited = appState.isFavorited(kart.id, FavoriteType.kart);

    return AppScaffold(
      appBar: AppBar(
        title: Text(kart.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
              color: AppColors.secondary,
            ),
            onPressed: () => appState.toggleFavorite(kart.id, FavoriteType.kart),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stats', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            StatBar(label: 'Speed', value: kart.speed),
            StatBar(label: 'Acceleration', value: kart.acceleration),
            StatBar(label: 'Weight', value: kart.weight),
            StatBar(label: 'Handling', value: kart.handling),
            StatBar(label: 'Traction', value: kart.traction),
          ],
        ),
      ),
    );
  }
}
