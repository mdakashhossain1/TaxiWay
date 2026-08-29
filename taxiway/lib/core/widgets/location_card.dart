import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../models/place_location.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../l10n/generated/app_localizations.dart';

/// Signature From / To Route Selector card matching Figma Screen 01.
class LocationCard extends StatelessWidget {
  final PlaceLocation? pickup;
  final PlaceLocation? destination;
  final VoidCallback onTapPickup;
  final VoidCallback onTapDestination;
  final VoidCallback? onSwap;

  const LocationCard({
    super.key,
    required this.pickup,
    required this.destination,
    required this.onTapPickup,
    required this.onTapDestination,
    this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasDestination = destination != null && destination!.address.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Vertical Indicator Track (Green Dot -> Dotted Line -> Orange Pin)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.35),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              // Dotted vertical connector
              CustomPaint(
                size: const Size(2, 28),
                painter: _DottedLinePainter(color: const Color(0xFFCBD5E1)),
              ),
              const SizedBox(height: 3),
              const Icon(
                BootstrapIcons.geo_alt_fill,
                color: AppColors.primary,
                size: 16,
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Middle: Pickup & Destination text sections
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // From (Pickup)
                InkWell(
                  onTap: onTapPickup,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From (Pickup)',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pickup?.shortName ?? (pickup?.address ?? l10n.searchPickup),
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                ),

                // To (Destination)
                InkWell(
                  onTap: onTapDestination,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To (Destination)',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.mutedText,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasDestination
                              ? destination!.shortName
                              : 'Where do you want to go?',
                          style: AppTypography.bodyLarge.copyWith(
                            color: hasDestination ? AppColors.navy : AppColors.primary,
                            fontWeight: hasDestination ? FontWeight.w700 : FontWeight.w600,
                            fontSize: 14.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right: Swap Button
          if (onSwap != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Material(
                color: const Color(0xFFFFF7ED),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Color(0xFFFED7AA), width: 1),
                ),
                child: InkWell(
                  onTap: onSwap,
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      BootstrapIcons.arrow_down_up,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  const _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double startY = 0.0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
