import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color tokens straight from design-system.pdf §1 "Palette".
///
/// This app is dark-theme only by design ("Dark mode: decided now" — no
/// light ColorScheme is maintained). Every color used anywhere in the app
/// must come from here; nothing should be hardcoded outside this file.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFFF3B30); // buttons, active nav tab, key CTAs
  static const Color onPrimary = Color(0xFFFFFFFF); // text/icons drawn on primary
  static const Color secondary = Color(0xFFFFD60A); // favorite star, highlights, unlock badges

  static const Color surface = Color(0xFF1B2030); // cards, sheets, bottom nav
  static const Color onSurface = Color(0xFFF5F7FA); // body text on surface/background
  static const Color error = Color(0xFFFF6B6B); // validation, destructive actions

  static const Color background = Color(0xFF10131A); // app background (dark theme)
  static const Color surfaceHigh = Color(0xFF262D42); // elevated / pressed state
  static const Color divider = Color(0xFF2A3044); // card borders, list dividers

  static const Color dataBlue = Color(0xFF4391FF); // track category tags, secondary badges
  static const Color success = Color(0xFF34C759); // unlocked check, Easy difficulty
  static const Color textSecondary = Color(0xFFA8B0C4); // subtitles, helper text
  static const Color textTertiary = Color(0xFF6E768A); // placeholders, disabled
}

/// Spacing tokens from design-system.pdf §2 "Spacing".
/// Base unit 4 · screen edge padding 20 · gap between list items 12 ·
/// gap between sections 24.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double pad = 20; // screen edge padding — the one-off outside xs/sm/md/lg/xl
  static const double lg = 24;
  static const double xl = 32;

  /// Gap between list items (card lists).
  static const double listGap = 12;

  /// Gap between sections on a screen.
  static const double sectionGap = 24;
}

/// Difficulty/class pill colors used on TrackCard and EntityListTile chips.
class AppDifficultyColors {
  AppDifficultyColors._();

  static Color forDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'hard':
        return AppColors.dataBlue;
      case 'medium':
      default:
        return AppColors.secondary;
    }
  }
}

ThemeData buildAppTheme() {
  final base = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);

  final textTheme = base.copyWith(
    // "Display" — hero name on detail screens (e.g. "Mario"). 30px Bold.
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    // "Heading" — screen titles ("Characters", "Tracks"). 24px Bold.
    headlineSmall: base.headlineSmall?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    // "Title" — card / list item names. 17px Bold.
    titleMedium: base.titleMedium?.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: AppColors.onSurface,
    ),
    // "Body" — descriptions, subtitles. 14px Regular.
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),
    // "Caption/Label" — tags, chips, nav labels. 11px Bold.
    labelSmall: base.labelSmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
    ),
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: Colors.black,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: AppColors.onPrimary,
    ),
    textTheme: textTheme,
    dividerColor: AppColors.divider,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.onSurface),
      titleTextStyle: textTheme.headlineSmall,
    ),
    // No custom CardTheme: every card-like surface in this app is built
    // with plain Material + InkWell (see widgets/), not the Card widget, to
    // avoid depending on a ThemeData.cardTheme type that has changed shape
    // across recent Flutter versions.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
    ),
    iconTheme: const IconThemeData(color: AppColors.onSurface),
    splashColor: AppColors.primary.withOpacity(0.15),
    highlightColor: Colors.transparent,
  );
}
