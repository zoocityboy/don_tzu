import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ============ LIGHT MODE (Aged Parchment) ============
  static const Color paperBase = Color(0xFFF5E6C8); // Aged parchment
  static const Color paperAged = Color(0xFFE8D5B7); // Darker aged
  static const Color paperDark = Color(0xFFD4C4A8); // Edge aging
  static const Color paperLight = Color(0xFFFAF3E8); // Light rice paper

  static const Color inkBlack = Color(0xFF1A1A1A); // Primary text
  static const Color inkGray = Color(0xFF3D3D3D); // Secondary text
  static const Color inkLight = Color(0xFF5A5A5A); // Light annotations

  static const Color vermillion = Color(0xFFC41E3A); // Seal red
  static const Color vermillionDark = Color(0xFF8B1428); // Darker seal

  static const Color antiqueGold = Color(0xFFB8860B); // Highlight accent
  static const Color agedBrown = Color(0xFF8B7355); // Brown aging

  // ============ DARK MODE (Aged Dark Parchment) ============
  static const Color darkPaperBase = Color(0xFF1C1812); // Dark aged parchment
  static const Color darkPaperAged = Color(0xFF2A241E); // Darker aged
  static const Color darkPaperDark = Color(0xFF3D352C); // Edge aging
  static const Color darkPaperLight = Color(0xFF2E2820); // Lighter dark

  static const Color darkInkBlack = Color(
    0xFF1A1A1A,
  ); // Primary (stays dark for contrast)
  static const Color darkInkGray = Color(
    0xFFB8A88A,
  ); // Secondary text (lighter)
  static const Color darkInkLight = Color(0xFFD4C4A8); // Light text

  // ============ LEGACY ============
  static const Color deepNavy = Color(0xFF1A1A2E);
  static const Color gold = Color(0xFFFFD700);
  static const Color likeActive = Color(0xFFFF4757);
}

class AppTheme {
  // Light mode - ancient manuscript parchment
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paperBase,
      colorScheme: const ColorScheme.light(
        primary: AppColors.inkBlack,
        secondary: AppColors.vermillion,
        surface: AppColors.paperBase,
        onPrimary: AppColors.paperBase,
        onSecondary: AppColors.paperBase,
        onSurface: AppColors.inkBlack,
      ),
      textTheme: _textThemeLight,
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.inkBlack,
      ),
    );
  }

  // Dark mode - aged dark parchment with proper contrast
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkPaperBase,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkInkLight,
        secondary: AppColors.vermillion,
        surface: AppColors.darkPaperBase,
        onPrimary: AppColors.darkPaperBase,
        onSecondary: AppColors.darkPaperBase,
        onSurface: AppColors.darkInkLight,
      ),
      textTheme: _textThemeDark,
      appBarTheme: const AppBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.darkInkLight,
      ),
    );
  }

  // Light text theme - ink on parchment
  static TextTheme get _textThemeLight {
    return TextTheme(
      displayLarge: GoogleFonts.notoSerifJp(
        fontSize: 22,
        color: AppColors.inkBlack,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: 0.5,
      ),
      displayMedium: GoogleFonts.notoSerifJp(
        fontSize: 18,
        color: AppColors.inkBlack,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: GoogleFonts.notoSerif(
        fontSize: 20,
        color: AppColors.inkGray,
        height: 1.8,
        letterSpacing: 0.3,
      ),
      bodyMedium: GoogleFonts.notoSerif(
        fontSize: 18,
        color: AppColors.inkLight,
        height: 1.7,
      ),
      labelLarge: GoogleFonts.notoSansJp(
        fontSize: 12,
        color: AppColors.inkGray,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.notoSansJp(
        fontSize: 10,
        color: AppColors.vermillion,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Dark text theme - lighter ink on dark paper
  static TextTheme get _textThemeDark {
    return TextTheme(
      displayLarge: GoogleFonts.notoSerifJp(
        fontSize: 22,
        color: AppColors.darkInkLight,
        fontWeight: FontWeight.w700,
        height: 1.4,
        letterSpacing: 0.5,
      ),
      displayMedium: GoogleFonts.notoSerifJp(
        fontSize: 18,
        color: AppColors.darkInkLight,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      bodyLarge: GoogleFonts.notoSerif(
        fontSize: 20,
        color: AppColors.darkInkGray,
        height: 1.8,
        letterSpacing: 0.3,
      ),
      bodyMedium: GoogleFonts.notoSerif(
        fontSize: 18,
        color: AppColors.darkInkGray,
        height: 1.7,
      ),
      labelLarge: GoogleFonts.notoSansJp(
        fontSize: 12,
        color: AppColors.darkInkGray,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.notoSansJp(
        fontSize: 10,
        color: AppColors.vermillion,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
