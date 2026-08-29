import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Clean, Modern Plus Jakarta Sans Typography System.
/// Uses elegant, balanced non-heavy weights for a sleek, lightweight, professional aesthetic.
class AppTypography {
  AppTypography._();

  static TextStyle _style({
    required double size,
    required double height,
    required FontWeight weight,
    Color color = AppColors.navy,
    double letterSpacing = -0.1,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      height: height / size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  /// Big Display Hero Heading (Splash, Welcome)
  static TextStyle display = _style(size: 48, height: 56, weight: FontWeight.w700, letterSpacing: -0.6);

  /// Primary Screen Headings
  static TextStyle h1 = _style(size: 28, height: 36, weight: FontWeight.w600, letterSpacing: -0.3);

  /// Section Headings & Card Titles
  static TextStyle h2 = _style(size: 22, height: 28, weight: FontWeight.w600, letterSpacing: -0.2);

  /// Sub-Headings & Subsection Titles
  static TextStyle h3 = _style(size: 18, height: 24, weight: FontWeight.w600, letterSpacing: -0.1);

  /// Large Body Text
  static TextStyle bodyLarge = _style(size: 17, height: 24, weight: FontWeight.w400, color: AppColors.navy);

  /// Standard Body Text (Clean, Lightweight)
  static TextStyle body = _style(size: 15.5, height: 22, weight: FontWeight.w400, color: AppColors.bodyText);

  /// Form Labels & Subsection Badges
  static TextStyle label = _style(size: 15.5, height: 21, weight: FontWeight.w500, color: AppColors.navy);

  /// Captions, Subtitles & Secondary Metrics
  static TextStyle caption = _style(size: 14, height: 19, weight: FontWeight.w400, color: AppColors.mutedText);

  /// Action Buttons & CTAs
  static TextStyle button = _style(size: 16, height: 22, weight: FontWeight.w600, letterSpacing: 0.1);

  /// Numeric Pricing & Fare Amounts
  static TextStyle price = _style(size: 26, height: 32, weight: FontWeight.w700, letterSpacing: -0.3);
}
