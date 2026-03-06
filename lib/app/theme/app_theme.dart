import 'package:flutter/material.dart';

final class AppTheme {
  static ThemeData light() {
    const surface = Color(0xFFF6F1E8);
    const primary = Color(0xFF0F3D3E);
    const secondary = Color(0xFFE07A5F);
    const tertiary = Color(0xFF81B29A);
    const dark = Color(0xFF1D1D1F);

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      tertiary: tertiary,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          height: 1.1,
          fontWeight: FontWeight.w800,
          color: dark,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: dark,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: dark,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: dark,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Color(0xFF404040),
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          height: 1.4,
          color: Color(0xFF5B5B5B),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        side: BorderSide.none,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

