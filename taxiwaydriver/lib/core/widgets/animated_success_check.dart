import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// The recurring "success" checkmark badge (Booking Confirmed, Ride
/// Completed, Bulk Booking Confirmed) with a consistent pop-in animation.
class AnimatedSuccessCheck extends StatelessWidget {
  final double size;
  final double iconSize;

  const AnimatedSuccessCheck({super.key, this.size = 44, this.iconSize = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size / 5),
      decoration: BoxDecoration(color: AppColors.of(context).successBackground, shape: BoxShape.circle),
      child: Icon(BootstrapIcons.check, color: AppColors.of(context).success, size: iconSize),
    )
        .animate()
        .scale(
          duration: 450.ms,
          curve: Curves.elasticOut,
          begin: const Offset(0.3, 0.3),
          end: const Offset(1, 1),
        )
        .fadeIn(duration: 200.ms);
  }
}
