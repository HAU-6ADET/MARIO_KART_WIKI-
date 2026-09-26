import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'screens/home_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MarioKartWorldWikiApp());
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
        // Dark-theme only, per design-system.pdf ("Dark mode: decided now").
        theme: buildAppTheme(),
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
