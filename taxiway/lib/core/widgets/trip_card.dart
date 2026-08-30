import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/geo_utils.dart';
import 'status_badge.dart';

class TripCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  const TripCard({super.key, required this.booking, required this.onTap});

  BadgeVariant get _variant {
    switch (booking.status) {
      case BookingStatus.completed:
        return BadgeVariant.verified;
      case BookingStatus.cancelled:
      case BookingStatus.failed:
        return BadgeVariant.cancelled;
      default:
        return BadgeVariant.pending;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.failed:
        return 'Failed';
      default:
        return 'Upcoming';
    }
  }

  String get _imageAsset {
    switch (booking.vehicleCategory.id) {
      case 'hatchback':
        return 'assets/images/car_hatchback.jpg';
      case 'suv':
        return 'assets/images/car_suv.jpg';
      case 'traveller':
      case 'tempo':
        return 'assets/images/car_traveller.jpg';
      case 'sedan':
      default:
        return 'assets/images/car_sedan.jpg';
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
          color: AppColors.of(context).card,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.of(context).border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 32,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(_imageAsset, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.vehicleCategory.name,
                          style: AppTypography.of(context).label.copyWith(fontWeight: FontWeight.w700, color: AppColors.of(context).navy),
                        ),
                        Text(
                          DateFormat('dd MMM, hh:mm a').format(booking.createdAt),
                          style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                StatusBadge(label: _statusLabel, variant: _variant),
              ],
            ),
            const SizedBox(height: 12),
            _RoutePoint(color: AppColors.of(context).success, text: booking.pickup.shortName),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: SizedBox(height: 14, child: VerticalDivider(width: 1, thickness: 1.5, color: AppColors.of(context).borderStrong)),
            ),
            _RoutePoint(color: AppColors.of(context).primary, text: booking.destination.shortName),
            const SizedBox(height: 12),
            Container(height: 1, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${booking.distanceKm.toStringAsFixed(1)} km · ${booking.etaMinutes} min',
                  style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText),
                ),
                Text(
                  formatRupees(booking.fare.total),
                  style: AppTypography.of(context).h3.copyWith(
                    color: AppColors.of(context).primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
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
            style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).navy, fontWeight: FontWeight.w600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
