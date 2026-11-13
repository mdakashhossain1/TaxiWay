import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../l10n/generated/app_localizations.dart';

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
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppRadius.input),
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
          Icon(AppIcons.chevron_down, size: 12, color: AppColors.of(context).mutedText),
          const SizedBox(width: 12),
          Container(width: 1, height: 26, color: AppColors.of(context).borderStrong),
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
                hintText: AppLocalizations.of(context).enterMobileNumber,
                hintStyle: AppTypography.of(context).body.copyWith(color: AppColors.of(context).mutedText),
                counterText: '',
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          if (onSimPickerTap != null) ...[
            Tooltip(
              message: AppLocalizations.of(context).autoFillSimNumber,
              child: InkWell(
                onTap: onSimPickerTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppIcons.sim_fill,
                        size: 16,
                        color: AppColors.of(context).navy,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SIM',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.of(context).navy,
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
