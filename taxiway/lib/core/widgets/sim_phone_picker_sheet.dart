import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class SimCardOption {
  final String slot;
  final String carrier;
  final String phoneNumber;
  final String raw10Digits;

  const SimCardOption({
    required this.slot,
    required this.carrier,
    required this.phoneNumber,
    required this.raw10Digits,
  });
}

/// A modern, native Google Play style SIM selector bottom sheet.
class SimPhonePickerSheet extends StatelessWidget {
  final ValueChanged<String> onSelected;

  const SimPhonePickerSheet({super.key, required this.onSelected});

  static const List<SimCardOption> defaultSimOptions = [
    SimCardOption(
      slot: 'SIM 1',
      carrier: 'Jio 4G',
      phoneNumber: '+91 98765 43210',
      raw10Digits: '9876543210',
    ),
    SimCardOption(
      slot: 'SIM 2',
      carrier: 'Airtel 5G',
      phoneNumber: '+91 87654 32109',
      raw10Digits: '8765432109',
    ),
  ];

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SimPhonePickerSheet(
        onSelected: (phone) => Navigator.of(ctx).pop(phone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header with SIM card icon
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.of(context).primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  BootstrapIcons.sim,
                  color: AppColors.of(context).primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continue with phone number',
                      style: AppTypography.of(context).h3.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.of(context).navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Select a number from your device SIM cards',
                      style: AppTypography.of(context).caption.copyWith(
                        color: AppColors.of(context).bodyText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(height: 1, color: AppColors.of(context).border),
          const SizedBox(height: 12),

          // SIM list items
          ...defaultSimOptions.map((sim) => _buildSimTile(context, sim)),

          const SizedBox(height: 8),

          // None of the above button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: Text(
                'None of the above',
                style: AppTypography.of(context).button.copyWith(
                  color: AppColors.of(context).secondaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimTile(BuildContext context, SimCardOption sim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.of(context).border),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.of(context).card,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.of(context).borderStrong),
          ),
          child: Center(
            child: Icon(BootstrapIcons.phone, size: 18, color: AppColors.of(context).navy),
          ),
        ),
        title: Text(
          sim.phoneNumber,
          style: AppTypography.of(context).bodyLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.of(context).navy,
            fontSize: 16,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.of(context).primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                sim.slot,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.of(context).primary,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              sim.carrier,
              style: AppTypography.of(context).caption.copyWith(
                color: AppColors.of(context).bodyText,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Icon(
          BootstrapIcons.arrow_right_circle_fill,
          color: AppColors.of(context).primary,
          size: 22,
        ),
        onTap: () => onSelected(sim.raw10Digits),
      ),
    );
  }
}
