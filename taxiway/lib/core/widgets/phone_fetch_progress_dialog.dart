import 'dart:async';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Non-dismissible overlay shown while Google Play Services' phone-number
/// hint dialog is loading, so the screen never appears blank during that gap.
class PhoneFetchProgressDialog {
  static bool _visible = false;

  static Future<void> show(BuildContext context) async {
    if (_visible) return;
    _visible = true;
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withValues(alpha: 0.35),
        builder: (dialogContext) => PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: BoxDecoration(
                color: AppColors.of(dialogContext).card,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.of(dialogContext).primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(BootstrapIcons.phone_fill, color: AppColors.of(dialogContext).primary, size: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Fetching your number',
                    style: AppTypography.of(dialogContext).h3.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.of(dialogContext).navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Checking your SIM for a phone number…',
                    textAlign: TextAlign.center,
                    style: AppTypography.of(dialogContext).caption.copyWith(
                      color: AppColors.of(dialogContext).bodyText,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: AppColors.of(dialogContext).primary.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(AppColors.of(dialogContext).primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    if (!_visible) return;
    _visible = false;
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
