import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'pressable_scale.dart';

class SheetActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const SheetActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final foreground = destructive ? colors.error : colors.navy;

    return PressableScale(
      pressedScale: 0.97,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: destructive ? colors.errorBackground : colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: foreground),
              const SizedBox(width: 8),
              Text(label, style: AppTypography.of(context).label.copyWith(color: foreground, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
