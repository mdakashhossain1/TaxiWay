import '../theme/app_icons.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.of(context).surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppColors.of(context).card,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Icon(AppIcons.calendar_event, color: AppColors.of(context).navy, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.upcomingScheduledRideTitle, style: AppTypography.of(context).label),
                    const SizedBox(height: 2),
                    Text(
                      scheduledLabel,
                      style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).secondaryText),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: isAssigned ? AppColors.of(context).success : AppColors.of(context).warning,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            isAssigned ? l10n.driverAssignedNameLabel(booking.driver!.name) : l10n.waitingForDriverLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.of(context).caption.copyWith(
                              color: isAssigned ? AppColors.of(context).success : AppColors.of(context).warningText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(AppIcons.chevron_right, color: AppColors.of(context).mutedText, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
