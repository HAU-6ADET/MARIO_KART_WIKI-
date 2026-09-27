// A widget test: it builds your app in memory and checks what is on screen.
// Run them all with: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mario_kart_world_wiki/main.dart';
import 'package:mario_kart_world_wiki/widgets/category_card.dart';

void main() {
  testWidgets('Home screen shows the title and all four category cards',
      (tester) async {
    // Build the app directly, not the DevicePreview wrapper, because a test
    // does not need the phone frame.
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    expect(find.text('Mario Kart World Wiki'), findsOneWidget);

    // Look for each label specifically inside a CategoryCard, not anywhere on
    // screen — "Tracks" and "Favorites" are also the labels of two
    // AppBottomNav tabs on this same screen, so a plain find.text('Tracks')
    // matches both the card and the nav item and fails findsOneWidget.
    expect(find.widgetWithText(CategoryCard, 'Characters'), findsOneWidget);
    expect(find.widgetWithText(CategoryCard, 'Tracks'), findsOneWidget);
    expect(find.widgetWithText(CategoryCard, 'Karts & Bikes'), findsOneWidget);
    expect(find.widgetWithText(CategoryCard, 'Favorites'), findsOneWidget);
  });

  testWidgets('Tapping the Characters card opens the Character Guide',
      (tester) async {
    await tester.pumpWidget(const MarioKartWorldWikiApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(CategoryCard, 'Characters'));
    await tester.pumpAndSettle();

    // The guide screen's AppBar title, plus at least one racer from the
    // bundled mock data.
    expect(find.text('Characters'), findsOneWidget);
    expect(find.text('Mario'), findsWidgets);
  });
}
