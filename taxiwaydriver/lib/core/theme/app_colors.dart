import 'package:flutter/material.dart';

/// Taxiway design system colors, as a [ThemeExtension] so every screen reacts
/// to light/dark mode automatically via `Theme.of(context)`.
/// Source: Taxiway_Complete_Design_Instructions.md §3.1
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  // Primary orange
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color primaryDark;
  final Color primaryDarker;
  final Color primaryLight;
  final Color primaryBackground;
  final Color primaryBorder;

  // Navy / text
  final Color navy;
  final Color navySecondary;
  final Color navyStrong;
  final Color bodyText;
  final Color secondaryText;
  final Color mutedText;

  // Neutral
  final Color appBackground;
  final Color surface;
  final Color card;
  final Color border;
  final Color borderStrong;

  // Status
  final Color success;
  final Color successBackground;
  final Color warning;
  final Color warningText;
  final Color warningBackground;
  final Color error;
  final Color errorBorder;
  final Color errorBackground;
  final Color info;
  final Color infoBackground;

  // Map
  final Color mapPickup;
  final Color mapDestination;
  final Color mapDriver;
  final Color mapRoute;

  const AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.primaryDark,
    required this.primaryDarker,
    required this.primaryLight,
    required this.primaryBackground,
    required this.primaryBorder,
    required this.navy,
    required this.navySecondary,
    required this.navyStrong,
    required this.bodyText,
    required this.secondaryText,
    required this.mutedText,
    required this.appBackground,
    required this.surface,
    required this.card,
    required this.border,
    required this.borderStrong,
    required this.success,
    required this.successBackground,
    required this.warning,
    required this.warningText,
    required this.warningBackground,
    required this.error,
    required this.errorBorder,
    required this.errorBackground,
    required this.info,
    required this.infoBackground,
    required this.mapPickup,
    required this.mapDestination,
    required this.mapDriver,
    required this.mapRoute,
  });

  static const light = AppColorsExtension(
    primary: Color(0xFF101114),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFFF97316),
    primaryDark: Color(0xFF2A2B30),
    primaryDarker: Color(0xFF000000),
    primaryLight: Color(0xFFEDEDEF),
    primaryBackground: Color(0xFFF4F4F5),
    primaryBorder: Color(0xFFE3E3E6),
    navy: Color(0xFF101114),
    navySecondary: Color(0xFF1F2024),
    navyStrong: Color(0xFF3A3B40),
    bodyText: Color(0xFF55565C),
    secondaryText: Color(0xFF65666C),
    mutedText: Color(0xFF74757B),
    appBackground: Color(0xFFFFFFFF),
    surface: Color(0xFFF4F4F5),
    card: Color(0xFFFFFFFF),
    border: Color(0xFFE8E8EA),
    borderStrong: Color(0xFFD0D0D4),
    success: Color(0xFF0E8A4F),
    successBackground: Color(0xFFE3F5EA),
    warning: Color(0xFFE8A100),
    warningText: Color(0xFF8A5A00),
    warningBackground: Color(0xFFFFF3D6),
    error: Color(0xFFD62B1F),
    errorBorder: Color(0xFFF5C2BD),
    errorBackground: Color(0xFFFDECEA),
    info: Color(0xFF1A5FD0),
    infoBackground: Color(0xFFE6EEFB),
    mapPickup: Color(0xFF101114),
    mapDestination: Color(0xFFF97316),
    mapDriver: Color(0xFF101114),
    mapRoute: Color(0xFF101114),
  );

  static const dark = AppColorsExtension(
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF0B0B0D),
    accent: Color(0xFFFB923C),
    primaryDark: Color(0xFFE4E4E7),
    primaryDarker: Color(0xFFD0D0D4),
    primaryLight: Color(0xFF2A2B30),
    primaryBackground: Color(0xFF1C1D21),
    primaryBorder: Color(0xFF34353B),
    navy: Color(0xFFFFFFFF),
    navySecondary: Color(0xFFF1F1F2),
    navyStrong: Color(0xFFD8D8DB),
    bodyText: Color(0xFFB9BABF),
    secondaryText: Color(0xFF9A9BA1),
    mutedText: Color(0xFF8B8C92),
    appBackground: Color(0xFF0B0B0D),
    surface: Color(0xFF1C1D21),
    card: Color(0xFF151618),
    border: Color(0xFF2B2C31),
    borderStrong: Color(0xFF3C3D43),
    success: Color(0xFF3DDC84),
    successBackground: Color(0xFF0F2A1B),
    warning: Color(0xFFFBBF24),
    warningText: Color(0xFFFCD34D),
    warningBackground: Color(0xFF3A2A06),
    error: Color(0xFFFF6B5E),
    errorBorder: Color(0xFF6B2A25),
    errorBackground: Color(0xFF3A1512),
    info: Color(0xFF6EA8FF),
    infoBackground: Color(0xFF12233F),
    mapPickup: Color(0xFFFFFFFF),
    mapDestination: Color(0xFFFB923C),
    mapDriver: Color(0xFFFFFFFF),
    mapRoute: Color(0xFFFFFFFF),
  );

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? onPrimary,
    Color? accent,
    Color? primaryDark,
    Color? primaryDarker,
    Color? primaryLight,
    Color? primaryBackground,
    Color? primaryBorder,
    Color? navy,
    Color? navySecondary,
    Color? navyStrong,
    Color? bodyText,
    Color? secondaryText,
    Color? mutedText,
    Color? appBackground,
    Color? surface,
    Color? card,
    Color? border,
    Color? borderStrong,
    Color? success,
    Color? successBackground,
    Color? warning,
    Color? warningText,
    Color? warningBackground,
    Color? error,
    Color? errorBorder,
    Color? errorBackground,
    Color? info,
    Color? infoBackground,
    Color? mapPickup,
    Color? mapDestination,
    Color? mapDriver,
    Color? mapRoute,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      accent: accent ?? this.accent,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryDarker: primaryDarker ?? this.primaryDarker,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryBackground: primaryBackground ?? this.primaryBackground,
      primaryBorder: primaryBorder ?? this.primaryBorder,
      navy: navy ?? this.navy,
      navySecondary: navySecondary ?? this.navySecondary,
      navyStrong: navyStrong ?? this.navyStrong,
      bodyText: bodyText ?? this.bodyText,
      secondaryText: secondaryText ?? this.secondaryText,
      mutedText: mutedText ?? this.mutedText,
      appBackground: appBackground ?? this.appBackground,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      success: success ?? this.success,
      successBackground: successBackground ?? this.successBackground,
      warning: warning ?? this.warning,
      warningText: warningText ?? this.warningText,
      warningBackground: warningBackground ?? this.warningBackground,
      error: error ?? this.error,
      errorBorder: errorBorder ?? this.errorBorder,
      errorBackground: errorBackground ?? this.errorBackground,
      info: info ?? this.info,
      infoBackground: infoBackground ?? this.infoBackground,
      mapPickup: mapPickup ?? this.mapPickup,
      mapDestination: mapDestination ?? this.mapDestination,
      mapDriver: mapDriver ?? this.mapDriver,
      mapRoute: mapRoute ?? this.mapRoute,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryDarker: Color.lerp(primaryDarker, other.primaryDarker, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryBackground: Color.lerp(primaryBackground, other.primaryBackground, t)!,
      primaryBorder: Color.lerp(primaryBorder, other.primaryBorder, t)!,
      navy: Color.lerp(navy, other.navy, t)!,
      navySecondary: Color.lerp(navySecondary, other.navySecondary, t)!,
      navyStrong: Color.lerp(navyStrong, other.navyStrong, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      appBackground: Color.lerp(appBackground, other.appBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBackground: Color.lerp(successBackground, other.successBackground, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      warningBackground: Color.lerp(warningBackground, other.warningBackground, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoBackground: Color.lerp(infoBackground, other.infoBackground, t)!,
      mapPickup: Color.lerp(mapPickup, other.mapPickup, t)!,
      mapDestination: Color.lerp(mapDestination, other.mapDestination, t)!,
      mapDriver: Color.lerp(mapDriver, other.mapDriver, t)!,
      mapRoute: Color.lerp(mapRoute, other.mapRoute, t)!,
    );
  }
}

/// Thin accessor kept for call-site familiarity — `AppColors.of(context).primary`
/// reads exactly like the old `AppColors.primary` static constant did.
class AppColors {
  AppColors._();

  static AppColorsExtension of(BuildContext context) =>
      Theme.of(context).extension<AppColorsExtension>()!;
}
