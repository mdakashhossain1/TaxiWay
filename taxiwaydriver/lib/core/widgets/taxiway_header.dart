import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'language_picker_sheet.dart';

/// Pass [lightMode] = true to render on dark backgrounds (white text).
class TaxiwayWordmark extends StatelessWidget {
  final double fontSize;
  final bool lightMode;
  const TaxiwayWordmark({super.key, this.fontSize = 22, this.lightMode = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Taxiway',
      style: AppTypography.h2.copyWith(
        fontSize: fontSize,
        color: lightMode ? Colors.white : AppColors.navy,
      ),
    );
  }
}

class TaxiwayHeader extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback? onSupportTap;

  const TaxiwayHeader({super.key, required this.onProfileTap, this.onSupportTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const TaxiwayWordmark(fontSize: 26),
              const SizedBox(height: 2),
              Text(
                'Safe. Reliable. Anytime.',
                style: AppTypography.caption.copyWith(
                  color: AppColors.mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Consumer(
                builder: (context, ref, _) => Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 1.5,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => showLanguagePickerSheet(context, ref),
                    child: const Padding(
                      padding: EdgeInsets.all(9),
                      child: Icon(BootstrapIcons.translate, size: 20, color: AppColors.navy),
                    ),
                  ),
                ),
              ),
              if (onSupportTap != null) ...[
                const SizedBox(width: 10),
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 1.5,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onSupportTap,
                    child: const Padding(
                      padding: EdgeInsets.all(9),
                      child: Icon(BootstrapIcons.chat_dots_fill, size: 20, color: AppColors.navy),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 10),
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 1.5,
                shadowColor: Colors.black26,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onProfileTap,
                  child: const Padding(
                    padding: EdgeInsets.all(9),
                    child: Icon(BootstrapIcons.person_fill, size: 20, color: AppColors.navy),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

