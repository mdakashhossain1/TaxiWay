import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../state/locale_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'language_tile.dart';

/// Quick language switcher used on the Home screen — applies instantly and
/// closes, unlike the full-page picker shown before first login.
Future<void> showLanguagePickerSheet(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context);
  final current = ref.read(localeControllerProvider).locale;

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.bottomSheet)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text(l10n.languagePickerTitle, style: AppTypography.h3),
            const SizedBox(height: 14),
            ...kSupportedLocales.map(
              (locale) => LanguageTile(
                label: languageDisplayName(l10n, locale),
                selected: current?.languageCode == locale.languageCode,
                onTap: () {
                  ref.read(localeControllerProvider.notifier).setLocale(locale);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
