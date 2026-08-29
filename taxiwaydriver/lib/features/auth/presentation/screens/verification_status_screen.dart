import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/app_config_repository.dart';
import '../../../../core/models/driver_profile.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/launch_utils.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Shown when a driver has logged in but has not completed offline
/// verification (Pending) or has been disabled by ops (Suspended).
class VerificationStatusScreen extends ConsumerWidget {
  const VerificationStatusScreen({super.key});

  Future<void> _callSupport(BuildContext context, WidgetRef ref) async {
    try {
      final number = await ref.read(appConfigRepositoryProvider).getSupportContactNumber();
      if (number == null || number.isEmpty) {
        if (context.mounted) {
          AppToast.error(context, 'Support number is not configured yet.', title: 'Unavailable');
        }
        return;
      }
      await launchPhoneCall(number);
    } catch (_) {
      if (context.mounted) {
        AppToast.error(context, 'Could not reach support right now. Please try again.', title: 'Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(authControllerProvider).driver;
    final isSuspended = driver?.verificationStatus == VerificationStatus.suspended;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isSuspended ? AppColors.errorBackground : AppColors.warningBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuspended ? BootstrapIcons.exclamation_triangle_fill : BootstrapIcons.hourglass_split,
                  size: 44,
                  color: isSuspended ? AppColors.error : AppColors.warningText,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                isSuspended ? l10n.accountSuspendedTitle : l10n.verificationPendingTitle,
                style: AppTypography.h1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isSuspended ? l10n.accountSuspendedMessage : l10n.verificationPendingMessage,
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: l10n.callOfficeSupport,
                icon: BootstrapIcons.telephone_fill,
                onPressed: () => _callSupport(context, ref),
              ),
              const SizedBox(height: 12),
              AppOutlineButton(
                label: l10n.backToLogin,
                onPressed: () {
                  ref.read(authControllerProvider.notifier).logout();
                  context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
