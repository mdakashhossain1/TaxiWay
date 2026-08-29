import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

/// Shows the customer for a ride, with a large one-tap Call action —
/// the driver-app equivalent of the customer app's DriverCompactCard.
class CustomerContactCard extends StatelessWidget {
  final String customerName;
  final String vehicleCategory;
  final VoidCallback onCall;

  const CustomerContactCard({
    super.key,
    required this.customerName,
    required this.vehicleCategory,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
            child: const Icon(BootstrapIcons.person_fill, color: AppColors.mutedText, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customerName, style: AppTypography.label.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(vehicleCategory, style: AppTypography.caption),
              ],
            ),
          ),
          CircleIconButton(icon: BootstrapIcons.telephone_fill, onPressed: onCall),
        ],
      ),
    );
  }
}
