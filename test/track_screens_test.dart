import 'package:flutter_test/flutter_test.dart';

import 'package:mario_kart_world_wiki/main.dart';

void main() {
  testWidgets('Track list and detail show racing info', (tester) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tracks').last);
    await tester.pumpAndSettle();

    expect(find.text('Moo Moo Meadows'), findsOneWidget);
    expect(find.text('Shell Cup · Race 1'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Rainbow Road'), 300);
    await tester.tap(find.text('Rainbow Road'));
    await tester.pumpAndSettle();

    expect(find.text('Special Cup · Race 4'), findsOneWidget);
    expect(find.text('Course overview'), findsOneWidget);
    expect(find.text('Shortcuts'), findsOneWidget);
    expect(find.text('Hazards'), findsOneWidget);
    expect(find.text('Strategy'), findsOneWidget);

    // New detail sections.
    expect(find.text('Course map'), findsOneWidget);
    expect(find.text('Sector guide'), findsOneWidget);
    expect(find.text('Skill tips'), findsOneWidget);
    expect(find.text('Common mistakes'), findsOneWidget);
    expect(find.text('Pit board'), findsOneWidget);
    expect(find.text('CHALLENGE'), findsOneWidget);
    expect(find.text('Lap-by-lap plan'), findsOneWidget);
    expect(find.text('Item tips'), findsOneWidget);
    expect(find.text('Best racers here'), findsOneWidget);
    expect(find.text('Recommended karts'), findsOneWidget);
    expect(find.text('Cup lineup'), findsOneWidget);
    expect(find.text('Did you know?'), findsOneWidget);
  });

  testWidgets('Track filter narrows the list by difficulty', (tester) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tracks').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hard'));
    await tester.pumpAndSettle();

    expect(find.text('Rainbow Road'), findsOneWidget);
    expect(find.text('Moo Moo Meadows'), findsNothing);
  });

  testWidgets('Home shows the featured race and quick stats', (tester) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    expect(find.text('FEATURED RACE'), findsOneWidget);
    expect(find.text('RACERS'), findsOneWidget);
    expect(find.text('COURSES'), findsOneWidget);
  });
}
