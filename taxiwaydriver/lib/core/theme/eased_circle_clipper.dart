import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';

/// [ThemeSwitcherCircleClipper] feeds the raw, linear [AnimationController]
/// value straight into the reveal radius, which reads as mechanical for a
/// full-screen wipe. Easing that value first makes the reveal accelerate
/// out of the tap and settle into place, which is what "smooth" looks like
/// for this kind of transition.
class EasedThemeSwitcherCircleClipper extends ThemeSwitcherCircleClipper {
  const EasedThemeSwitcherCircleClipper({this.curve = Curves.easeInOutCubic});

  final Curve curve;

  @override
  Path getClip(Size size, Offset? offset, double? sizeRate) {
    return super.getClip(size, offset, sizeRate == null ? null : curve.transform(sizeRate));
  }
}
