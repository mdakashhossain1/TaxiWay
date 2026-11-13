import 'package:flutter/material.dart';
import '../models/driver_ride.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/format_utils.dart';
import 'pressable_scale.dart';
import 'status_badge.dart';
import 'auto_scroll_text.dart';

class DriverRideCard extends StatelessWidget {
  final DriverRide ride;
  final VoidCallback onTap;

  const DriverRideCard({super.key, required this.ride, required this.onTap});

  BadgeVariant get _variant {
    switch (ride.status) {
      case DriverRideStatus.completed:
        return BadgeVariant.verified;
      case DriverRideStatus.cancelled:
        return BadgeVariant.cancelled;
      case DriverRideStatus.scheduledOpen:
        return BadgeVariant.info;
      case DriverRideStatus.upcoming:
      case DriverRideStatus.offered:
        return BadgeVariant.pending;
    }
  }

  String get _statusLabel {
    switch (ride.status) {
      case DriverRideStatus.completed:
        return 'Completed';
      case DriverRideStatus.cancelled:
        return 'Cancelled';
      case DriverRideStatus.offered:
        return 'Offered';
      case DriverRideStatus.scheduledOpen:
        return 'Open';
      case DriverRideStatus.upcoming:
        return 'Upcoming';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);

    return PressableScale(
      pressedScale: 0.98,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                child: Column(
                  children: [
                    Text(
                      formatRideDate(ride.dateTime).split(' ').first,
                      style: type.h2.copyWith(color: colors.onPrimary, fontSize: 22),
                    ),
                    Text(
                      formatRideDate(ride.dateTime).split(' ').last,
                      style: type.caption.copyWith(color: colors.onPrimary.withValues(alpha: 0.75), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatRideTime(ride.dateTime), style: type.label.copyWith(fontWeight: FontWeight.w700)),
                        StatusBadge(label: _statusLabel, variant: _variant),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _RoutePoint(isPickup: true, text: ride.pickup),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SizedBox(
                        height: 12,
                        child: VerticalDivider(width: 1, thickness: 1.5, color: colors.borderStrong),
                      ),
                    ),
                    _RoutePoint(isPickup: false, text: ride.destination),
                    const SizedBox(height: 12),
                    Text(formatRupees(ride.fare), style: type.h3.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final bool isPickup;
  final String text;

  const _RoutePoint({required this.isPickup, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: isPickup ? colors.navy : colors.accent,
            shape: isPickup ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isPickup ? null : BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AutoScrollText(
            text,
            style: AppTypography.of(context).body.copyWith(fontWeight: FontWeight.w600, color: colors.navy),
          ),
        ),
      ],
    );
  }
}
