import 'package:flutter/material.dart';

import '../data/kart_extras.dart';
import '../data/mock_data.dart';
import '../models/kart.dart';
import '../theme/theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/checkered_strip.dart';
import '../widgets/kart_card.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'kart_detail_screen.dart';
import 'track_guide_screen.dart';

/// The garage: every kart and bike as a card, with a Karts / Bikes filter.
class KartGuideScreen extends StatefulWidget {
  const KartGuideScreen({super.key});

  @override
  State<KartGuideScreen> createState() => _KartGuideScreenState();
}

class _KartGuideScreenState extends State<KartGuideScreen> {
  String? _type; // null == "All"

  static const _filters = <String?>[null, 'Kart', 'Bike'];

  void _openTab(BuildContext context, int index) {
    if (index == 2) return; // already on Karts
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
      return;
    }
    final target = index == 1
        ? const TrackGuideScreen()
        : const FavoritesScreen();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => target));
  }

  String _label(String? type) =>
      type == null ? 'All' : (type == 'Kart' ? 'Karts' : 'Bikes');

  @override
  Widget build(BuildContext context) {
    final List<Kart> visible = _type == null
        ? MockData.karts
        : MockData.karts
              .where((k) => KartExtras.of(k.id).type == _type)
              .toList();

    return AppScaffold(
      appBar: AppBar(title: const Text('Karts & Bikes')),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (i) => _openTab(context, i),
      ),
      body: Column(
        children: [
          // Plain Wrap (not a scrolling row) so the page has one scroll view.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pad),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final filter in _filters)
                    ChoiceChip(
                      avatar: Icon(
                        filter == 'Bike'
                            ? Icons.two_wheeler_rounded
                            : Icons.directions_car_filled_rounded,
                        size: 16,
                        color: _type == filter
                            ? Colors.black87
                            : AppColors.dataBlue,
                      ),
                      label: Text(_label(filter)),
                      showCheckmark: false,
                      selected: _type == filter,
                      onSelected: (_) => setState(() => _type = filter),
                      selectedColor: AppColors.dataBlue,
                      backgroundColor: AppColors.surfaceHigh,
                      labelStyle: TextStyle(
                        color: _type == filter
                            ? Colors.black87
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide.none,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const CheckeredStrip(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pad,
              AppSpacing.md - 4,
              AppSpacing.pad,
              0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${visible.length} in the garage',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.pad),
              itemCount: visible.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.listGap),
              itemBuilder: (context, index) {
                final kart = visible[index];
                return KartCard(
                  kart: kart,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => KartDetailScreen(kartId: kart.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
