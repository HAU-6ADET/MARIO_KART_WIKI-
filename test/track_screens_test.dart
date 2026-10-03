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
  });

  testWidgets('Home shows the featured race and quick stats', (tester) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    expect(find.text('FEATURED RACE'), findsOneWidget);
    expect(find.text('RACERS'), findsOneWidget);
    expect(find.text('COURSES'), findsOneWidget);
  });
}
