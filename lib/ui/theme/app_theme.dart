import 'package:flutter/material.dart';

// ── Colour palette (mirrors Kotlin theme) ──────────────────────
const Color kCyberBg = Color(0xFF080B1A);
const Color kCyberCard = Color(0xFF0F1428);
const Color kNeonTeal = Color(0xFF00E5CC);
const Color kNeonPurple = Color(0xFF8B5CF6);
const Color kStellarWhite = Color(0xFFF0F4FF);
const Color kCyberGray = Color(0xFF6B7280);
const Color kPremiumGold = Color(0xFFFBBF24);
const Color kDangerRed = Color(0xFFEF4444);
const Color kSuccessGreen = Color(0xFF4ADE80);

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kCyberBg,
        colorScheme: const ColorScheme.dark(
          primary: kNeonTeal,
          secondary: kNeonPurple,
          surface: kCyberCard,
          onPrimary: kCyberBg,
          onSecondary: kStellarWhite,
          onSurface: kStellarWhite,
        ),
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: kCyberBg,
          foregroundColor: kStellarWhite,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: kCyberCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kNeonTeal),
          ),
          labelStyle: TextStyle(color: kCyberGray),
          hintStyle: TextStyle(color: kCyberGray.withOpacity(0.6)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kNeonTeal,
            foregroundColor: kCyberBg,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              color: kStellarWhite,
              fontSize: 28,
              fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
              color: kStellarWhite,
              fontSize: 20,
              fontWeight: FontWeight.w600),
          titleMedium: TextStyle(
              color: kStellarWhite,
              fontSize: 16,
              fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: kStellarWhite, fontSize: 15),
          bodyMedium: TextStyle(color: kCyberGray, fontSize: 13),
          labelSmall: TextStyle(
              color: kNeonTeal,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600),
        ),
      );
}
