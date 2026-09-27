// This is your app. This template's own DevicePreview wiring (see
// START-HERE.md and the original template lib/main.dart) is kept below: the
// toolbar it adds still works, it is just wrapped around
// MarioKartWorldWikiApp instead of the placeholder counter screen.

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'screens/home_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    // DevicePreview draws a phone frame around your app, so it is judged at
    // the size it was designed for instead of stretched across a laptop
    // window.
    //
    // It is left ON in the deployed build on purpose: your live link is
    // opened on a desktop browser, and a phone layout at full desktop width
    // looks broken when it is not. The toolbar also lets a visitor switch
    // device and orientation.
    //
    // Want the clean app with no frame instead? Add
    //   import 'package:flutter/foundation.dart' show kReleaseMode;
    // and set `enabled: !kReleaseMode`, which drops the frame in release
    // builds.
    DevicePreview(
      enabled: true,
      builder: (context) => const MarioKartWorldWikiApp(),
    ),
  );
}

class MarioKartWorldWikiApp extends StatefulWidget {
  const MarioKartWorldWikiApp({super.key});

  @override
  State<MarioKartWorldWikiApp> createState() => _MarioKartWorldWikiAppState();
}

class _MarioKartWorldWikiAppState extends State<MarioKartWorldWikiApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _appState,
      child: MaterialApp(
        title: 'Mario Kart World Wiki',
        debugShowCheckedModeBanner: false,

        // These two lines are what make the DevicePreview toolbar actually
        // change the app. Keep them.
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,

        // Dark-theme only, per design-system.pdf ("Dark mode: decided now").
        theme: buildAppTheme(),
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
