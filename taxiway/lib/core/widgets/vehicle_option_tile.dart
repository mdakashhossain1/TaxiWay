import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../models/vehicle_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../utils/geo_utils.dart';
import 'app_network_image.dart';
import 'pressable_scale.dart';

class VehicleOptionTile extends StatelessWidget {
  final VehicleCategory category;
  final double fare;
  final bool selected;
  final VoidCallback onTap;

  const VehicleOptionTile({
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
    final background = selected ? colors.surface : colors.card;
    final fallback = Center(child: Icon(AppIcons.car_front_fill, color: colors.navy, size: 26));

    return PressableScale(
      pressedScale: 0.98,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: selected ? colors.primary : Colors.transparent, width: 2),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 84,
                height: 52,
                child: (category.imageUrl != null && category.imageUrl!.isNotEmpty)
                    ? AppNetworkImage(url: category.imageUrl!, fallback: fallback)
                    : Image.asset(
                        _imageAsset,
                        fit: BoxFit.contain,
                        color: background,
                        colorBlendMode: BlendMode.multiply,
                        errorBuilder: (context, error, stackTrace) => fallback,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: type.label.copyWith(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(AppIcons.person_fill, size: 12, color: colors.secondaryText),
                        const SizedBox(width: 2),
                        Text('${category.seats}', style: type.caption.copyWith(color: colors.secondaryText)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.minutesShort(category.etaMinutes),
                      style: type.caption.copyWith(color: colors.secondaryText),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(formatRupees(fare), style: type.h3.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }
}
