import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Single source of truth for the app's look. Change colors here, not in
/// individual screens.
class AppTheme {
  AppTheme._();

  static const background = Color(0xFF14161C);
  static const surface = Color(0xFF1E2129);
  static const divider = Color(0xFF2C303A);

  /// Sampled from assets/brand/logo.jpg — the school's own brand color,
  /// used for every interactive accent (buttons, active states, badges).
  static const brandPink = Color(0xFFF48FC7);

  /// Feedback colors stay semantic (green/red/amber) no matter the brand.
  static const correct = Color(0xFF2EAA5D);
  static const incorrect = Color(0xFFE24C42);
  static const amber = Color(0xFFF5C518);

  static const radius = 14.0;

  static TextTheme get _textTheme {
    final base = GoogleFonts.manropeTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.35,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandPink,
        brightness: Brightness.dark,
        surface: surface,
      ),
      useMaterial3: true,
      textTheme: _textTheme,
    );
    return base.copyWith(
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
    );
  }
}
