import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Simple horizontal usage bar for "rides used / total" style visuals.
class UsageProgressBar extends StatelessWidget {
  final double fraction;
  final Color trackColor;
  final Color? fillColor;
  final double height;

  const UsageProgressBar({
    super.key,
    required this.fraction,
    this.trackColor = Colors.white,
    this.fillColor,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: fraction.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: trackColor,
        valueColor: AlwaysStoppedAnimation(fillColor ?? AppColors.of(context).primary),
      ),
    );
  }
}
