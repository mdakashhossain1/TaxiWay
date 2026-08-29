import 'package:flutter/material.dart';

/// Taxiway design system colors.
/// Source: Taxiway_Complete_Design_Instructions.md §3.1
class AppColors {
  AppColors._();

  // Primary orange
  static const Color primary = Color(0xFFF97316);
  static const Color primaryDark = Color(0xFFEA580C);
  static const Color primaryDarker = Color(0xFFC2410C);
  static const Color primaryLight = Color(0xFFFFEDD5);
  static const Color primaryBackground = Color(0xFFFFF7ED);
  static const Color primaryBorder = Color(0xFFFED7AA);

  // Navy / text
  static const Color navy = Color(0xFF0F172A);
  static const Color navySecondary = Color(0xFF1E293B);
  static const Color navyStrong = Color(0xFF334155);
  static const Color bodyText = Color(0xFF475569);
  static const Color secondaryText = Color(0xFF64748B);
  static const Color mutedText = Color(0xFF94A3B8);

  // Neutral
  static const Color appBackground = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFF1F5F9);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderStrong = Color(0xFFCBD5E1);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color successBackground = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningText = Color(0xFFD97706);
  static const Color warningBackground = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFDC2626);
  static const Color errorBorder = Color(0xFFFECACA);
  static const Color errorBackground = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF2563EB);
  static const Color infoBackground = Color(0xFFDBEAFE);

  // Map
  static const Color mapPickup = success;
  static const Color mapDestination = primary;
  static const Color mapDriver = navy;
  static const Color mapRoute = primary;
}
