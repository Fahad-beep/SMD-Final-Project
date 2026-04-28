import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color midnight = Color(0xFF0E1320);
  static const Color midnightSoft = Color(0xFF171E31);
  static const Color lilac = Color(0xFF7D68F7);
  static const Color sky = Color(0xFF5ED3F3);
  static const Color coral = Color(0xFFFF8E72);
  static const Color sand = Color(0xFFF6F1E8);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: lilac,
      brightness: Brightness.light,
      primary: lilac,
      secondary: sky,
      tertiary: coral,
      surface: const Color(0xFFF5F7FC),
      background: sand,
    );
    return _themeFromScheme(
      scheme,
      scaffoldColor: const Color(0xFFF4F7FB),
      cardColor: Colors.white,
      borderColor: const Color(0xFFE1E7F3),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: lilac,
      brightness: Brightness.dark,
      primary: const Color(0xFF9A8CFF),
      secondary: sky,
      tertiary: coral,
      surface: midnightSoft,
      background: midnight,
    );
    return _themeFromScheme(
      scheme,
      scaffoldColor: midnight,
      cardColor: midnightSoft,
      borderColor: const Color(0xFF283048),
    );
  }

  static ThemeData _themeFromScheme(
    ColorScheme scheme, {
    required Color scaffoldColor,
    required Color cardColor,
    required Color borderColor,
  }) {
    final textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: MaterialStatePropertyAll(
          textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scaffoldColor,
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardColor,
        selectedColor: scheme.primaryContainer,
        labelStyle: textTheme.labelLarge,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      dividerTheme: DividerThemeData(color: borderColor),
      extensions: const [],
    );
  }
}
