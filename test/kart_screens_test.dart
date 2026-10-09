import 'package:flutter_test/flutter_test.dart';

import 'package:mario_kart_world_wiki/data/kart_extras.dart';
import 'package:mario_kart_world_wiki/data/mock_data.dart';
import 'package:mario_kart_world_wiki/main.dart';
import 'package:mario_kart_world_wiki/widgets/category_card.dart';

void main() {
  test('every kart has a profile and sane computed stats', () {
    for (final k in MockData.karts) {
      final extras = KartExtras.of(k.id);
      expect(
        extras,
        isNot(same(KartExtras.fallback)),
        reason: '${k.name} has no KartExtras entry',
      );
      expect(extras.strengths, isNotEmpty);
      expect(extras.weaknesses, isNotEmpty);
      expect(kartOverall(k), inInclusiveRange(0, 100));
    }
  });

  testWidgets('Karts list filters by type and the profile shows sections', (
    tester,
  ) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CategoryCard, 'Karts & Bikes'));
    await tester.pumpAndSettle();

    expect(find.text('Standard Kart'), findsOneWidget);
    expect(find.text('Yoshi Bike'), findsOneWidget);

    await tester.tap(find.text('Bikes'));
    await tester.pumpAndSettle();
    expect(find.text('Yoshi Bike'), findsOneWidget);
    expect(find.text('Standard Kart'), findsNothing);

    await tester.tap(find.text('Yoshi Bike'));
    await tester.pumpAndSettle();

    expect(find.text('Garage briefing'), findsOneWidget);
    expect(find.text('Stats'), findsOneWidget);
    expect(find.text('Vs. the garage'), findsOneWidget);
    expect(find.text('Strengths'), findsOneWidget);
    expect(find.text('Weaknesses'), findsOneWidget);
    expect(find.text('Setup tips'), findsOneWidget);
    expect(find.text('Great on these courses'), findsOneWidget);
    expect(find.textContaining('OVERALL'), findsWidgets);
  });
}
