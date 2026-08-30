import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Clean, Modern Plus Jakarta Sans Typography System, as a [ThemeExtension]
/// so text colors follow light/dark mode via `Theme.of(context)`.
/// Uses elegant, balanced non-heavy weights for a sleek, lightweight, professional aesthetic.
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final TextStyle display;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle bodyLarge;
  final TextStyle body;
  final TextStyle label;
  final TextStyle caption;
  final TextStyle button;
  final TextStyle price;

  const AppTypographyExtension({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.bodyLarge,
    required this.body,
    required this.label,
    required this.caption,
    required this.button,
    required this.price,
  });

  static TextStyle _style({
    required double size,
    required double height,
    required FontWeight weight,
    required Color color,
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

  factory AppTypographyExtension.build({required AppColorsExtension colors}) {
    return AppTypographyExtension(
      /// Big Display Hero Heading (Splash, Welcome)
      display: _style(size: 48, height: 56, weight: FontWeight.w700, color: colors.navy, letterSpacing: -0.6),

      /// Primary Screen Headings
      h1: _style(size: 28, height: 36, weight: FontWeight.w600, color: colors.navy, letterSpacing: -0.3),

      /// Section Headings & Card Titles
      h2: _style(size: 22, height: 28, weight: FontWeight.w600, color: colors.navy, letterSpacing: -0.2),

      /// Sub-Headings & Subsection Titles
      h3: _style(size: 18, height: 24, weight: FontWeight.w600, color: colors.navy, letterSpacing: -0.1),

      /// Large Body Text
      bodyLarge: _style(size: 17, height: 24, weight: FontWeight.w400, color: colors.navy),

      /// Standard Body Text (Clean, Lightweight)
      body: _style(size: 15.5, height: 22, weight: FontWeight.w400, color: colors.bodyText),

      /// Form Labels & Subsection Badges
      label: _style(size: 15.5, height: 21, weight: FontWeight.w500, color: colors.navy),

      /// Captions, Subtitles & Secondary Metrics
      caption: _style(size: 14, height: 19, weight: FontWeight.w400, color: colors.mutedText),

      /// Action Buttons & CTAs
      button: _style(size: 16, height: 22, weight: FontWeight.w600, color: colors.navy, letterSpacing: 0.1),

      /// Numeric Pricing & Fare Amounts
      price: _style(size: 26, height: 32, weight: FontWeight.w700, color: colors.navy, letterSpacing: -0.3),
    );
  }

  @override
  AppTypographyExtension copyWith({
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? bodyLarge,
    TextStyle? body,
    TextStyle? label,
    TextStyle? caption,
    TextStyle? button,
    TextStyle? price,
  }) {
    return AppTypographyExtension(
      display: display ?? this.display,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      body: body ?? this.body,
      label: label ?? this.label,
      caption: caption ?? this.caption,
      button: button ?? this.button,
      price: price ?? this.price,
    );
  }

  @override
  AppTypographyExtension lerp(ThemeExtension<AppTypographyExtension>? other, double t) {
    if (other is! AppTypographyExtension) return this;
    return AppTypographyExtension(
      display: TextStyle.lerp(display, other.display, t)!,
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      price: TextStyle.lerp(price, other.price, t)!,
    );
  }
}

/// Thin accessor kept for call-site familiarity — `AppTypography.of(context).h1`
/// reads exactly like the old `AppTypography.h1` static field did.
class AppTypography {
  AppTypography._();

  static AppTypographyExtension of(BuildContext context) =>
      Theme.of(context).extension<AppTypographyExtension>()!;
}
