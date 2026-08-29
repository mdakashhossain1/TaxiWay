import 'package:flutter/material.dart';
import '../models/driver_ride.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/format_utils.dart';
import 'status_badge.dart';

/// Large, date-forward ride card for the driver's My Rides list.
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
      case DriverRideStatus.upcoming:
        return 'Upcoming';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(color: AppColors.navy.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Big date badge.
            Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground,
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: Column(
                children: [
                  Text(
                    formatRideDate(ride.dateTime).split(' ').first,
                    style: AppTypography.h2.copyWith(color: AppColors.primaryDark, fontSize: 20),
                  ),
                  Text(
                    formatRideDate(ride.dateTime).split(' ').last,
                    style: AppTypography.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600),
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
                      Text(formatRideTime(ride.dateTime), style: AppTypography.label.copyWith(fontWeight: FontWeight.w700)),
                      StatusBadge(label: _statusLabel, variant: _variant),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _RoutePoint(color: AppColors.success, text: ride.pickup),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: SizedBox(height: 12, child: VerticalDivider(width: 1, thickness: 1.5, color: AppColors.borderStrong)),
                  ),
                  _RoutePoint(color: AppColors.primary, text: ride.destination),
                  const SizedBox(height: 10),
                  Text(formatRupees(ride.fare), style: AppTypography.h3.copyWith(color: AppColors.primaryDark)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  final Color color;
  final String text;

  const _RoutePoint({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
