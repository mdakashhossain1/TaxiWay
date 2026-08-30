import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSimPickerTap;

  const PhoneInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSimPickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: AppColors.of(context).border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Text('🇮🇳', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(
            '+91',
            style: AppTypography.of(context).bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.of(context).navy,
            ),
          ),
          const SizedBox(width: 4),
          Icon(BootstrapIcons.chevron_down, size: 12, color: AppColors.of(context).mutedText),
          const SizedBox(width: 12),
          Container(width: 1, height: 26, color: AppColors.of(context).border),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: AppTypography.of(context).bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.of(context).navy,
                letterSpacing: 0.5,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Enter mobile number',
                hintStyle: AppTypography.of(context).body.copyWith(color: AppColors.of(context).mutedText),
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          if (onSimPickerTap != null) ...[
            Tooltip(
              message: 'Auto-fill SIM number',
              child: InkWell(
                onTap: onSimPickerTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        BootstrapIcons.sim_fill,
                        size: 16,
                        color: AppColors.of(context).primary.withValues(alpha: 0.85),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SIM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.of(context).primary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}
