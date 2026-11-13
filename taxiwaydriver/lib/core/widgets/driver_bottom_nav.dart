import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

enum DriverNavTab { rides, subscription }

class DriverBottomNav extends StatelessWidget {
  final DriverNavTab? selected;
  final ValueChanged<DriverNavTab> onSelect;

  const DriverBottomNav({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: AppIcons.car_front_fill,
                  label: 'Rides',
                  active: selected == DriverNavTab.rides,
                  onTap: () => onSelect(DriverNavTab.rides),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: AppIcons.credit_card_fill,
                  label: 'Subscription',
                  active: selected == DriverNavTab.subscription,
                  onTap: () => onSelect(DriverNavTab.subscription),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final color = active ? colors.navy : colors.mutedText;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            decoration: BoxDecoration(
              color: active ? colors.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.of(context).caption.copyWith(
              color: color,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
