import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';
import '../models/booking.dart';
import '../providers.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Shown on the home screen when the customer has a scheduled ride that
/// hasn't completed/been cancelled yet — before a driver accepts it just
/// says "waiting for a driver"; once one does, shows their name (per the
/// request: "he can see the person name and the driver name who is in
/// schedule").
class UpcomingScheduledRideCard extends ConsumerWidget {
  const UpcomingScheduledRideCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final booking = ref.watch(nextScheduledBookingProvider);
    if (booking == null) return const SizedBox.shrink();

    final isAssigned = booking.status != BookingStatus.scheduledOpen && booking.driver != null;
    final scheduledLabel = booking.scheduledAt != null ? DateFormat('d MMM, h:mm a').format(booking.scheduledAt!) : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.tripHistory),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.of(context).card,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.of(context).primary.withValues(alpha: 0.4), width: 1.2),
            boxShadow: [
              BoxShadow(color: const Color(0xFF0F172A).withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(BootstrapIcons.calendar_event, color: AppColors.of(context).primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.upcomingScheduledRideTitle, style: AppTypography.of(context).h3.copyWith(color: AppColors.of(context).navy)),
                    const SizedBox(height: 2),
                    Text(scheduledLabel, style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText)),
                    const SizedBox(height: 4),
                    Text(
                      isAssigned ? l10n.driverAssignedNameLabel(booking.driver!.name) : l10n.waitingForDriverLabel,
                      style: AppTypography.of(context).caption.copyWith(
                        color: isAssigned ? AppColors.of(context).success : AppColors.of(context).warningText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(BootstrapIcons.chevron_right, color: AppColors.of(context).mutedText, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
