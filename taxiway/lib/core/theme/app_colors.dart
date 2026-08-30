import 'package:flutter/material.dart';

/// Taxiway design system colors, as a [ThemeExtension] so every screen reacts
/// to light/dark mode automatically via `Theme.of(context)`.
/// Source: Taxiway_Complete_Design_Instructions.md §3.1
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  // Primary orange
  final Color primary;
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
    primary: Color(0xFFF97316),
    primaryDark: Color(0xFFEA580C),
    primaryDarker: Color(0xFFC2410C),
    primaryLight: Color(0xFFFFEDD5),
    primaryBackground: Color(0xFFFFF7ED),
    primaryBorder: Color(0xFFFED7AA),
    navy: Color(0xFF0F172A),
    navySecondary: Color(0xFF1E293B),
    navyStrong: Color(0xFF334155),
    bodyText: Color(0xFF475569),
    secondaryText: Color(0xFF64748B),
    mutedText: Color(0xFF94A3B8),
    appBackground: Color(0xFFF8FAFC),
    surface: Color(0xFFF1F5F9),
    card: Color(0xFFFFFFFF),
    border: Color(0xFFE2E8F0),
    borderStrong: Color(0xFFCBD5E1),
    success: Color(0xFF16A34A),
    successBackground: Color(0xFFDCFCE7),
    warning: Color(0xFFF59E0B),
    warningText: Color(0xFFD97706),
    warningBackground: Color(0xFFFEF3C7),
    error: Color(0xFFDC2626),
    errorBorder: Color(0xFFFECACA),
    errorBackground: Color(0xFFFEE2E2),
    info: Color(0xFF2563EB),
    infoBackground: Color(0xFFDBEAFE),
    mapPickup: Color(0xFF16A34A),
    mapDestination: Color(0xFFF97316),
    mapDriver: Color(0xFF0F172A),
    mapRoute: Color(0xFFF97316),
  );

  static const dark = AppColorsExtension(
    primary: Color(0xFFFB923C),
    primaryDark: Color(0xFFF97316),
    primaryDarker: Color(0xFFEA580C),
    primaryLight: Color(0xFF431407),
    primaryBackground: Color(0xFF1F0F06),
    primaryBorder: Color(0xFF9A3412),
    navy: Color(0xFFF8FAFC),
    navySecondary: Color(0xFFF1F5F9),
    navyStrong: Color(0xFFE2E8F0),
    bodyText: Color(0xFFCBD5E1),
    secondaryText: Color(0xFF94A3B8),
    mutedText: Color(0xFF64748B),
    appBackground: Color(0xFF020617),
    surface: Color(0xFF1E293B),
    card: Color(0xFF1E293B),
    border: Color(0xFF334155),
    borderStrong: Color(0xFF475569),
    success: Color(0xFF4ADE80),
    successBackground: Color(0xFF052E16),
    warning: Color(0xFFFBBF24),
    warningText: Color(0xFFFCD34D),
    warningBackground: Color(0xFF451A03),
    error: Color(0xFFF87171),
    errorBorder: Color(0xFF991B1B),
    errorBackground: Color(0xFF450A0A),
    info: Color(0xFF60A5FA),
    infoBackground: Color(0xFF172554),
    mapPickup: Color(0xFF4ADE80),
    mapDestination: Color(0xFFFB923C),
    mapDriver: Color(0xFFF8FAFC),
    mapRoute: Color(0xFFFB923C),
  );

  @override
  AppColorsExtension copyWith({
    Color? primary,
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
