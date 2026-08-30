import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../l10n/generated/app_localizations.dart';

String languageDisplayName(AppLocalizations l10n, Locale locale) {
  switch (locale.languageCode) {
    case 'hi':
      return l10n.languageHindi;
    case 'bn':
      return l10n.languageBengali;
    default:
      return l10n.languageEnglish;
  }
}

class LanguageTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const LanguageTile({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.of(context).primaryBackground : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: selected ? AppColors.of(context).primary : AppColors.of(context).border, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.of(context).bodyLarge.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.of(context).primaryDark : AppColors.of(context).navy,
                ),
              ),
            ),
            Icon(
              selected ? BootstrapIcons.check_circle_fill : BootstrapIcons.circle,
              color: selected ? AppColors.of(context).primary : AppColors.of(context).border,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
