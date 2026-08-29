import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum DriverNavTab { rides, subscription }

/// The driver app's only bottom navigation — exactly 2 destinations per the
/// PRD ("No other main tabs in V1."). Used on Dashboard, My Rides, and
/// Subscription so a driver is never more than one tap away from either.
class DriverBottomNav extends StatelessWidget {
  final DriverNavTab? selected;
  final ValueChanged<DriverNavTab> onSelect;

  const DriverBottomNav({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: BootstrapIcons.car_front_fill,
                  label: 'Rides',
                  active: selected == DriverNavTab.rides,
                  onTap: () => onSelect(DriverNavTab.rides),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: BootstrapIcons.credit_card_fill,
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
    final color = active ? AppColors.primary : AppColors.mutedText;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.caption.copyWith(color: color, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
