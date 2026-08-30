import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_back_button.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

/// Assembles the Taxiway Material theme from the design tokens.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light, AppColorsExtension.light);

  static ThemeData get dark => _build(Brightness.dark, AppColorsExtension.dark);

  static ThemeData _build(Brightness brightness, AppColorsExtension colors) {
    final base = ThemeData(useMaterial3: true, brightness: brightness);
    final typography = AppTypographyExtension.build(colors: colors);

    return base.copyWith(
      scaffoldBackgroundColor: colors.appBackground,
      colorScheme: base.colorScheme.copyWith(
        primary: colors.primary,
        onPrimary: Colors.white,
        secondary: colors.primaryDark,
        surface: colors.card,
        error: colors.error,
      ),
      extensions: [colors, typography],
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        TextTheme(
          displayLarge: typography.display,
          headlineLarge: typography.h1,
          headlineMedium: typography.h2,
          titleMedium: typography.h3,
          bodyLarge: typography.bodyLarge,
          bodyMedium: typography.body,
          labelLarge: typography.label,
          bodySmall: typography.caption,
          labelSmall: typography.caption,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.navy),
        titleTextStyle: typography.h3,
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => const AppBackButton(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.mutedText.withValues(alpha: 0.4),
          minimumSize: const Size.fromHeight(52),
          textStyle: typography.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.navy,
          minimumSize: const Size.fromHeight(52),
          textStyle: typography.button,
          side: BorderSide(color: colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.card,
        hintStyle: typography.bodyLarge.copyWith(color: colors.mutedText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.border, thickness: 1, space: 1),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
