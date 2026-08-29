import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Clean, Modern Plus Jakarta Sans Typography System.
/// Sized larger than the customer app per the Driver App typography rule
/// (18-22px section labels, 16px minimum body/labels, 24-32px key numbers) —
/// drivers need large, highly readable text with no training required.
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
  static TextStyle bodyLarge = _style(size: 18, height: 26, weight: FontWeight.w400, color: AppColors.navy);

  /// Standard Body Text — 16px floor for anything operational.
  static TextStyle body = _style(size: 16, height: 22, weight: FontWeight.w400, color: AppColors.bodyText);

  /// Form Labels & Subsection Badges — 16px floor.
  static TextStyle label = _style(size: 16, height: 22, weight: FontWeight.w500, color: AppColors.navy);

  /// Captions carrying operational meaning (still readable, never tiny).
  static TextStyle caption = _style(size: 16, height: 21, weight: FontWeight.w400, color: AppColors.mutedText);

  /// Genuinely disposable metadata only (timestamps, footnotes).
  static TextStyle captionSmall = _style(size: 13, height: 18, weight: FontWeight.w400, color: AppColors.mutedText);

  /// Action Buttons & CTAs
  static TextStyle button = _style(size: 18, height: 24, weight: FontWeight.w600, letterSpacing: 0.1);

  /// Numeric Pricing & Fare Amounts
  static TextStyle price = _style(size: 30, height: 36, weight: FontWeight.w700, letterSpacing: -0.3);

  /// Dominant key numbers (rides used/remaining, subscription price).
  static TextStyle priceLarge = _style(size: 32, height: 38, weight: FontWeight.w700, letterSpacing: -0.4);
}
