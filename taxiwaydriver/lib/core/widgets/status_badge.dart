import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

enum BadgeVariant { verified, active, pending, cancelled, expired, info }

class StatusBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final IconData? icon;

  const StatusBadge({super.key, required this.label, required this.variant, this.icon});

  ({Color bg, Color fg}) _colors(BuildContext context) {
    switch (variant) {
      case BadgeVariant.verified:
      case BadgeVariant.active:
        return (bg: AppColors.of(context).successBackground, fg: AppColors.of(context).success);
      case BadgeVariant.pending:
        return (bg: AppColors.of(context).warningBackground, fg: AppColors.of(context).warningText);
      case BadgeVariant.cancelled:
      case BadgeVariant.expired:
        return (bg: AppColors.of(context).errorBackground, fg: AppColors.of(context).error);
      case BadgeVariant.info:
        return (bg: AppColors.of(context).infoBackground, fg: AppColors.of(context).info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: c.bg, borderRadius: BorderRadius.circular(AppRadius.badge)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 13, color: c.fg), const SizedBox(width: 4)],
          Text(label, style: AppTypography.of(context).caption.copyWith(color: c.fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
