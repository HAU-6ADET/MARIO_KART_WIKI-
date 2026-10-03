import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// The wallpaper: a dark base color with the line-art item pattern
/// (assets/background/main.jpg) laid over it.
///
/// Wrapped in a [RepaintBoundary] because it never changes, so Flutter can
/// cache it instead of repainting it every time a list scrolls above it.
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: AppColors.background),
          Opacity(
            opacity: AppBackdrop.imageOpacity,
            child: Image.asset(
              AppBackdrop.asset,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              // If the file is ever missing, just show the plain dark color.
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Drop-in replacement for [Scaffold] that paints [AppBackground] behind the
/// screen, so the wallpaper is the main background of the whole app. Each
/// page carries its own copy, so nothing bleeds through from the page
/// underneath during a page transition.
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const AppBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }
}
