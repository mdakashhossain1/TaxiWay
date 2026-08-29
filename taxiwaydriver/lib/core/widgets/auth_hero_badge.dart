import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Large illustrated icon badge used on the onboarding, phone-login and OTP
/// screens: a glowing gradient circle with a big icon, sparkle accents, and
/// an optional small overlapping status badge (e.g. a checkmark).
class AuthHeroBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final IconData? badgeIcon;
  final Color? badgeColor;

  const AuthHeroBadge({
    super.key,
    required this.icon,
    this.color = AppColors.primary,
    this.size = 108,
    this.badgeIcon,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final stage = size * 1.7;
    return SizedBox(
      width: stage,
      height: stage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: stage,
            height: stage,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.08)),
          ),
          Container(
            width: stage * 0.72,
            height: stage * 0.72,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.10)),
          ),
          Positioned(
            top: stage * 0.06,
            right: stage * 0.1,
            child: Icon(BootstrapIcons.stars, size: 18, color: color.withValues(alpha: 0.55)),
          ),
          Positioned(
            bottom: stage * 0.16,
            left: stage * 0.02,
            child: Icon(BootstrapIcons.stars, size: 13, color: color.withValues(alpha: 0.4)),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, Color.lerp(color, Colors.black, 0.18)!],
              ),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 28, offset: const Offset(0, 12))],
            ),
            child: Icon(icon, color: Colors.white, size: size * 0.44),
          ),
          if (badgeIcon != null)
            Positioned(
              bottom: stage * 0.14,
              right: stage * 0.14,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Container(
                  padding: EdgeInsets.all(size * 0.06),
                  decoration: BoxDecoration(color: badgeColor ?? AppColors.success, shape: BoxShape.circle),
                  child: Icon(badgeIcon, color: Colors.white, size: size * 0.2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
