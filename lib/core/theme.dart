import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoXeyColors {
  static const Color blackRussian = Color(0xFF050110);
  static const Color radicalRed = Color(0xFFF8326D);
  static const Color neonLime = Color(0xFFB9FF66);
  static const Color softGrey = Color(0xFF2D2D3D);
  static const Color deepPurple = Color(0xFF130133);
  static const Color accentPurple = Color(0xFF8A32F8);
  static const Color glassSurface = Color(0x1AFFFFFF);
  static const Color ghostWhite = Color(0xFFF5F5F7);
  
  // GXBank Specific Colors
  static const Color gxPurple = Color(0xFF6B32FB);
  static const Color gxDarkCard = Color(0xFF1C1C24);
  static const Color gxCyan = Color(0xFF38DBFF);
  static const Color gxBgTop = Color(0xFF300346);
  static const Color gxBgBottom = Color(0xFF0F021F);
}

class GoXeyTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: GoXeyColors.blackRussian,
      primaryColor: GoXeyColors.radicalRed,
      colorScheme: ColorScheme.dark(
        primary: GoXeyColors.radicalRed,
        secondary: GoXeyColors.accentPurple,
        surface: GoXeyColors.deepPurple,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GoXeyColors.radicalRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      cardTheme: const CardThemeData(
        color: GoXeyColors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        elevation: 0,
      ),
    );
  }
}
