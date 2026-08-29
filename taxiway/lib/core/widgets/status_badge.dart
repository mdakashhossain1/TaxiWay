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

  ({Color bg, Color fg}) get _colors {
    switch (variant) {
      case BadgeVariant.verified:
      case BadgeVariant.active:
        return (bg: AppColors.successBackground, fg: AppColors.success);
      case BadgeVariant.pending:
        return (bg: AppColors.warningBackground, fg: AppColors.warningText);
      case BadgeVariant.cancelled:
      case BadgeVariant.expired:
        return (bg: AppColors.errorBackground, fg: AppColors.error);
      case BadgeVariant.info:
        return (bg: AppColors.infoBackground, fg: AppColors.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: c.bg, borderRadius: BorderRadius.circular(AppRadius.badge)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 13, color: c.fg), const SizedBox(width: 4)],
          Text(label, style: AppTypography.caption.copyWith(color: c.fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
