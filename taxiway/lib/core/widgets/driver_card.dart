import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../models/driver.dart';
import '../models/vehicle.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';
import 'rating_stars.dart';
import 'status_badge.dart';

/// Circular photo placeholder or avatar.
class DriverAvatar extends StatelessWidget {
  final double size;
  const DriverAvatar({super.key, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          BootstrapIcons.person_fill,
          color: Colors.white,
          size: size * 0.55,
        ),
      ),
    );
  }
}

/// Compact driver card used on Booking Confirmed / Live Tracking.
class DriverCompactCard extends StatelessWidget {
  final Driver driver;
  final Vehicle vehicle;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final VoidCallback? onViewProfile;

  const DriverCompactCard({
    super.key,
    required this.driver,
    required this.vehicle,
    this.onCall,
    this.onMessage,
    this.onViewProfile,
  });

  String get _vehicleImage {
    final cat = vehicle.category.toLowerCase();
    if (cat.contains('hatchback')) return 'assets/images/car_hatchback.jpg';
    if (cat.contains('suv')) return 'assets/images/car_suv.jpg';
    if (cat.contains('traveller') || cat.contains('tempo')) return 'assets/images/car_traveller.jpg';
    return 'assets/images/car_sedan.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DriverAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.name,
                      style: AppTypography.h3.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        RatingStars(rating: driver.rating, size: 13),
                        const SizedBox(width: 6),
                        Text(
                          driver.rating.toStringAsFixed(1),
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (driver.isFullyVerified)
                const StatusBadge(
                  label: 'Verified',
                  variant: BadgeVariant.verified,
                  icon: BootstrapIcons.patch_check_fill,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0xFFE2E8F0)),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 36,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(_vehicleImage, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.model,
                      style: AppTypography.bodyLarge.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    Text(
                      vehicle.registrationNumber,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onCall != null || onMessage != null || onViewProfile != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (onViewProfile != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewProfile,
                      icon: const Icon(BootstrapIcons.person, size: 16, color: AppColors.navy),
                      label: Text(
                        'Profile',
                        style: AppTypography.label.copyWith(color: AppColors.navy),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                      ),
                    ),
                  ),
                if (onMessage != null && onViewProfile != null) const SizedBox(width: 10),
                if (onMessage != null)
                  SizedBox(
                    width: 44,
                    height: 42,
                    child: CircleIconButton(
                      icon: BootstrapIcons.chat_dots_fill,
                      onPressed: onMessage!,
                      background: AppColors.surface,
                      foreground: AppColors.navy,
                    ),
                  ),
                if (onCall != null && (onViewProfile != null || onMessage != null)) const SizedBox(width: 10),
                if (onCall != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onCall,
                      icon: const Icon(BootstrapIcons.telephone_fill, size: 16, color: Colors.white),
                      label: Text(
                        'Call',
                        style: AppTypography.button.copyWith(color: Colors.white, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size.fromHeight(42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
