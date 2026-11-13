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
        onPrimary: colors.onPrimary,
        secondary: colors.accent,
        outline: colors.border,
        surfaceContainerHighest: colors.surface,
        surface: colors.card,
        error: colors.error,
      ),
      extensions: [colors, typography],
      textTheme: GoogleFonts.interTextTheme(
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
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.surface,
          disabledForegroundColor: colors.mutedText,
          minimumSize: const Size.fromHeight(54),
          textStyle: typography.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.navy,
          minimumSize: const Size.fromHeight(54),
          textStyle: typography.button,
          side: BorderSide(color: colors.borderStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: typography.bodyLarge.copyWith(color: colors.mutedText),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.card,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionColor: colors.accent.withValues(alpha: 0.25),
        selectionHandleColor: colors.accent,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colors.primary),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(colors.card),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? colors.primary : colors.borderStrong,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerTheme: DividerThemeData(color: colors.border, thickness: 1, space: 1),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
