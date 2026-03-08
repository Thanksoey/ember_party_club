import 'package:flutter/material.dart';

final class AppTheme {
  static ThemeData light() {
    return _buildTheme(_ThemePalette.light());
  }

  static ThemeData dark() {
    return _buildTheme(_ThemePalette.dark());
  }

  static ThemeData _buildTheme(_ThemePalette palette) {
    final scheme =
        ColorScheme.fromSeed(
          brightness: palette.brightness,
          seedColor: palette.primary,
        ).copyWith(
          primary: palette.primary,
          secondary: palette.secondary,
          tertiary: palette.tertiary,
          surface: palette.surface,
          outline: palette.outline,
          onPrimary: palette.brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF190A04),
          onSecondary: const Color(0xFF2B1A07),
          onTertiary: const Color(0xFF031A17),
          onSurface: palette.text,
        );

    final textTheme = TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        height: 1.02,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.4,
        color: palette.text,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        height: 1.14,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
        color: palette.text,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        color: palette.text,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: palette.text,
      ),
      bodyLarge: TextStyle(fontSize: 15, height: 1.52, color: palette.body),
      bodyMedium: TextStyle(
        fontSize: 13,
        height: 1.4,
        color: palette.body.withValues(alpha: 0.92),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.3,
        color: palette.body.withValues(alpha: 0.84),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: palette.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: palette.background,
      cardColor: palette.surface,
      visualDensity: const VisualDensity(horizontal: -0.1, vertical: -0.05),
      splashFactory: InkRipple.splashFactory,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.secondary,
        circularTrackColor: palette.outline.withValues(alpha: 0.22),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: palette.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        color: palette.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: palette.outline.withValues(alpha: 0.72)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        modalBackgroundColor: palette.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: palette.secondary, width: 1.4),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface.withValues(alpha: 0.95),
        indicatorColor: palette.tertiary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? palette.primary
                : palette.body,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: FontWeight.w800,
            color: states.contains(WidgetState.selected)
                ? palette.text
                : palette.body,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 46),
          side: BorderSide(color: palette.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        minVerticalPadding: 8,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: palette.outline)),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return palette.primary.withValues(alpha: 0.14);
            }
            return palette.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return palette.primary;
            }
            return palette.text;
          }),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: palette.brightness == Brightness.light
            ? const Color(0xFF2C1812)
            : const Color(0xFFF9EDE5),
        contentTextStyle: TextStyle(
          color: palette.brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF32190F),
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.primary.withValues(alpha: 0.08),
        selectedColor: palette.secondary.withValues(alpha: 0.18),
        labelStyle: textTheme.bodyMedium,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      dividerColor: palette.outline,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: _SmoothFadeSlidePageTransitionsBuilder(),
          TargetPlatform.iOS: _SmoothFadeSlidePageTransitionsBuilder(),
          TargetPlatform.windows: _SmoothFadeSlidePageTransitionsBuilder(),
          TargetPlatform.macOS: _SmoothFadeSlidePageTransitionsBuilder(),
          TargetPlatform.linux: _SmoothFadeSlidePageTransitionsBuilder(),
          TargetPlatform.fuchsia: _SmoothFadeSlidePageTransitionsBuilder(),
        },
      ),
    );
  }
}

class _SmoothFadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const _SmoothFadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.015, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

final class _ThemePalette {
  const _ThemePalette({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.outline,
    required this.text,
    required this.body,
    required this.inputFill,
  });

  factory _ThemePalette.light() => const _ThemePalette(
    brightness: Brightness.light,
    background: Color(0xFFFFF6EE),
    surface: Color(0xFFFFFBF7),
    primary: Color(0xFFE45B2A),
    secondary: Color(0xFFFFB64D),
    tertiary: Color(0xFF1FC9B7),
    outline: Color(0xFFE7CBB6),
    text: Color(0xFF2D1A13),
    body: Color(0xFF684D40),
    inputFill: Color(0xFFFFF3E8),
  );

  factory _ThemePalette.dark() => const _ThemePalette(
    brightness: Brightness.dark,
    background: Color(0xFF130C0A),
    surface: Color(0xFF1E1411),
    primary: Color(0xFFFF7C42),
    secondary: Color(0xFFFFCC66),
    tertiary: Color(0xFF3CE5CC),
    outline: Color(0xFF4C352A),
    text: Color(0xFFFFEFE5),
    body: Color(0xFFD9BDAF),
    inputFill: Color(0xFF2B1C16),
  );

  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color outline;
  final Color text;
  final Color body;
  final Color inputFill;
}
