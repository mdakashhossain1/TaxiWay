import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../models/vehicle_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/geo_utils.dart';

class VehicleCard extends StatelessWidget {
  final VehicleCategory category;
  final double fare;
  final bool selected;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.category,
    required this.fare,
    required this.selected,
    required this.onTap,
  });

  String get _imageAsset {
    switch (category.id) {
      case 'hatchback':
        return 'assets/images/car_hatchback.jpg';
      case 'suv':
        return 'assets/images/car_suv.jpg';
      case 'traveller':
        return 'assets/images/car_traveller.jpg';
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 148,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBackground : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: selected ? 2.0 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: selected ? 10 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Vehicle Image Preview
            Container(
              height: 64,
              width: double.infinity,
              decoration: BoxDecoration(
                color: selected ? Colors.white : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(AppRadius.medium),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: (category.imageUrl != null && category.imageUrl!.isNotEmpty)
                    ? Image.network(
                        category.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            BootstrapIcons.car_front_fill,
                            color: selected ? AppColors.primary : AppColors.navy,
                            size: 26,
                          ),
                        ),
                      )
                    : Image.asset(
                        _imageAsset,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            BootstrapIcons.car_front_fill,
                            color: selected ? AppColors.primary : AppColors.navy,
                            size: 26,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),

            // Vehicle Category Title (e.g. 3 Seater Hatchback)
            Text(
              '${category.seats} Seater\n${category.name}',
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Price in Bold Rupees
            Text(
              formatRupees(fare),
              style: AppTypography.h3.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: selected ? AppColors.primaryDark : AppColors.navy,
              ),
            ),

            // ETA and Checkmark indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${category.etaMinutes} min',
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color: selected ? AppColors.primaryDark : AppColors.mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (selected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 11,
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
