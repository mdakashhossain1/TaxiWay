import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// The compact failure state for a section inside a larger screen: says what
/// failed and offers a retry, without taking over the page.
class InlineRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const InlineRetry({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.exclamation_circle, size: 24, color: colors.mutedText),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.of(context).body.copyWith(color: colors.bodyText),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(AppIcons.arrow_clockwise, size: 16),
            label: Text(AppLocalizations.of(context).tryAgainLabel),
          ),
        ],
      ),
    );
  }
}
