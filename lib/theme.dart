import 'package:flutter/material.dart';

class KaalaTeekaTheme {

  static const Color primary = Color.fromARGB(255, 120, 26, 26);

  // Dark backgrounds
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color muted = Color(0xFF242424);

  // Accent colors
  static const Color accent = Color(0xFFE76F51);
  static const Color danger = Color(0xFFE63946);

  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF7A7A7A);

  // Borders
  static const Color border = Color(0xFF2E2E2E);

  // ===== TEXT STYLES =====

  static final TextStyle heading1 = TextStyle(
    color: textPrimary,
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
  );

  static final TextStyle heading2 = TextStyle(
    color: textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle paragraph = TextStyle(
    color: textSecondary,
    fontSize: 15,
    height: 1.7,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle smallMuted = TextStyle(
    color: textMuted,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // ===== THEME =====

  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: background,
      primaryColor: primary,

      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
      ),

      // ===== APP BAR =====

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),

      // ===== CARD =====

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: border,
            width: 1,
          ),
        ),
      ),

      // ===== BUTTON =====

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ===== INPUT FIELDS =====

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: muted,

        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        hintStyle: TextStyle(
          color: textMuted,
          fontSize: 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: border,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      // ===== BOTTOM NAVIGATION =====

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),

      // ===== ICONS =====

      iconTheme: IconThemeData(
        color: textPrimary,
      ),

      // ===== DIVIDERS =====

      dividerColor: border,
    );
  }
}