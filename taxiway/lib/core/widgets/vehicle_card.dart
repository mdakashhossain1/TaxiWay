import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../models/vehicle_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';
import '../utils/geo_utils.dart';
import 'app_network_image.dart';
import 'pressable_scale.dart';

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
        return 'assets/images/car_hatchback.webp';
      case 'suv':
        return 'assets/images/car_suv.webp';
      case 'traveller':
        return 'assets/images/car_traveller.webp';
      case 'tempo':
        return 'assets/images/car_traveller.webp';
      case 'sedan':
      default:
        return 'assets/images/car_sedan.webp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final fallbackIcon = Center(child: Icon(AppIcons.car_front_fill, color: colors.navy, size: 26));

    return PressableScale(
      pressedScale: 0.97,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 152,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: selected ? colors.card : colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: selected ? colors.primary : Colors.transparent, width: 2),
            boxShadow: selected ? AppShadows.selected : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 62,
                width: double.infinity,
                child: (category.imageUrl != null && category.imageUrl!.isNotEmpty)
                    ? AppNetworkImage(url: category.imageUrl!, fallback: fallbackIcon)
                    : Image.asset(
                        _imageAsset,
                        fit: BoxFit.contain,
                        color: selected ? colors.card : colors.surface,
                        colorBlendMode: BlendMode.multiply,
                        errorBuilder: (context, error, stackTrace) => fallbackIcon,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: type.label.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 1),
              Text(
                '${l10n.seaterCount(category.seats)} · ${l10n.minutesShort(category.etaMinutes)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: type.caption.copyWith(color: colors.secondaryText),
              ),
              const SizedBox(height: 6),
              Text(formatRupees(fare), style: type.h3.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
