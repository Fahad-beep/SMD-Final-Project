import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color midnight = Color(0xFF0B1320);
  static const Color midnightSoft = Color(0xFF151D2D);
  static const Color ocean = Color(0xFF2F6F75);
  static const Color sky = Color(0xFF63C7D8);
  static const Color coral = Color(0xFFE58B6D);
  static const Color sand = Color(0xFFF6F1E7);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: ocean,
      brightness: Brightness.light,
      primary: ocean,
      secondary: sky,
      tertiary: coral,
      surface: const Color(0xFFF4F7F8),
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
      seedColor: ocean,
      brightness: Brightness.dark,
      primary: const Color(0xFF7DD3DA),
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
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
