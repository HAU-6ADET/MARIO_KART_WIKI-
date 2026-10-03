import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mario_kart_world_wiki/data/character_extras.dart';
import 'package:mario_kart_world_wiki/data/mock_data.dart';
import 'package:mario_kart_world_wiki/main.dart';
import 'package:mario_kart_world_wiki/widgets/category_card.dart';

void main() {
  test('every racer has a profile whose links point at real data', () {
    for (final c in MockData.characters) {
      final extras = CharacterExtras.of(c.id);
      expect(extras, isNot(same(CharacterExtras.fallback)),
          reason: '${c.name} has no CharacterExtras entry');
      expect(extras.bio, isNotEmpty);
      expect(extras.strengths, isNotEmpty);
      expect(extras.weaknesses, isNotEmpty);
      for (final trackId in extras.bestTrackIds) {
        expect(MockData.tracks.where((t) => t.id == trackId), isNotEmpty,
            reason: '${c.name} -> unknown track $trackId');
      }
      for (final kartId in c.bestPairedWithKartIds) {
        expect(MockData.kartById(kartId), isNotNull,
            reason: '${c.name} -> unknown kart $kartId');
      }
      expect(c.overallRating, inInclusiveRange(0, 100));
    }
  });

  test('racer numbers are unique', () {
    final numbers = MockData.characters
        .map((c) => CharacterExtras.of(c.id).racerNumber)
        .toList();
    expect(numbers.toSet().length, numbers.length);
  });

  testWidgets('Character guide shows racer cards and filters by class',
      (tester) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CategoryCard, 'Characters'));
    await tester.pumpAndSettle();

    expect(find.text('Mario'), findsWidgets);
    expect(find.text('The benchmark racer'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Lightweight'));
    await tester.pumpAndSettle();

    expect(find.text('Toad'), findsOneWidget);
    expect(find.text('Mario'), findsNothing);
  });

  testWidgets('Character detail shows the driver profile', (tester) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CategoryCard, 'Characters'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Bowser'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Bowser'));
    await tester.pumpAndSettle();

    expect(find.text('Heavyweight king'), findsOneWidget);
    expect(find.text('NO. 4'), findsOneWidget);
    expect(find.text('Driver profile'), findsOneWidget);
    expect(find.text('Pit board'), findsOneWidget);
    expect(find.text('Strengths'), findsOneWidget);
    expect(find.text('Weaknesses'), findsOneWidget);
    expect(find.text('Best tracks'), findsOneWidget);
    expect(find.text('How to unlock'), findsOneWidget);
    expect(find.text('Pit talk'), findsOneWidget);
  });
}
