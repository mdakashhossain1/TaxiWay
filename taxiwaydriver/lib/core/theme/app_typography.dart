import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Clean, Modern Plus Jakarta Sans Typography System, as a [ThemeExtension]
/// so text colors follow light/dark mode via `Theme.of(context)`.
/// Sized larger than the customer app per the Driver App typography rule
/// (18-22px section labels, 16px minimum body/labels, 24-32px key numbers) —
/// drivers need large, highly readable text with no training required.
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  final TextStyle display;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle bodyLarge;
  final TextStyle body;
  final TextStyle label;
  final TextStyle caption;
  final TextStyle captionSmall;
  final TextStyle button;
  final TextStyle price;
  final TextStyle priceLarge;

  const AppTypographyExtension({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.bodyLarge,
    required this.body,
    required this.label,
    required this.caption,
    required this.captionSmall,
    required this.button,
    required this.price,
    required this.priceLarge,
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
      bodyLarge: _style(size: 18, height: 26, weight: FontWeight.w400, color: colors.navy),

      /// Standard Body Text — 16px floor for anything operational.
      body: _style(size: 16, height: 22, weight: FontWeight.w400, color: colors.bodyText),

      /// Form Labels & Subsection Badges — 16px floor.
      label: _style(size: 16, height: 22, weight: FontWeight.w500, color: colors.navy),

      /// Captions carrying operational meaning (still readable, never tiny).
      caption: _style(size: 16, height: 21, weight: FontWeight.w400, color: colors.mutedText),

      /// Genuinely disposable metadata only (timestamps, footnotes).
      captionSmall: _style(size: 13, height: 18, weight: FontWeight.w400, color: colors.mutedText),

      /// Action Buttons & CTAs
      button: _style(size: 18, height: 24, weight: FontWeight.w600, color: colors.navy, letterSpacing: 0.1),

      /// Numeric Pricing & Fare Amounts
      price: _style(size: 30, height: 36, weight: FontWeight.w700, color: colors.navy, letterSpacing: -0.3),

      /// Dominant key numbers (rides used/remaining, subscription price).
      priceLarge: _style(size: 32, height: 38, weight: FontWeight.w700, color: colors.navy, letterSpacing: -0.4),
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
    TextStyle? captionSmall,
    TextStyle? button,
    TextStyle? price,
    TextStyle? priceLarge,
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
      captionSmall: captionSmall ?? this.captionSmall,
      button: button ?? this.button,
      price: price ?? this.price,
      priceLarge: priceLarge ?? this.priceLarge,
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
      captionSmall: TextStyle.lerp(captionSmall, other.captionSmall, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      price: TextStyle.lerp(price, other.price, t)!,
      priceLarge: TextStyle.lerp(priceLarge, other.priceLarge, t)!,
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
