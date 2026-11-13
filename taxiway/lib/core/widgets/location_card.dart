import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import '../models/place_location.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../l10n/generated/app_localizations.dart';

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
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);
    final hasDestination = destination != null && destination!.address.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: colors.navy, shape: BoxShape.circle),
              ),
              CustomPaint(
                size: const Size(2, 34),
                painter: _DottedLinePainter(color: colors.borderStrong),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: colors.accent, borderRadius: BorderRadius.circular(2)),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onTapPickup,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.fromPickupLabel, style: type.caption.copyWith(color: colors.secondaryText)),
                          const SizedBox(height: 1),
                          Text(
                            pickup?.shortName ?? (pickup?.address ?? l10n.searchPickup),
                            style: type.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colors.border),
                InkWell(
                  onTap: onTapDestination,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.toDestinationLabel, style: type.caption.copyWith(color: colors.secondaryText)),
                          const SizedBox(height: 1),
                          Text(
                            hasDestination ? destination!.shortName : l10n.whereDoYouWantToGo,
                            style: type.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: hasDestination ? colors.navy : colors.mutedText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onSwap != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Material(
                color: colors.card,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onSwap,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(AppIcons.arrow_down_up, size: 15, color: colors.navy),
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
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    const dashHeight = 3.0;
    const dashSpace = 3.0;
    double startY = 3.0;

    while (startY < size.height - 3) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) => oldDelegate.color != color;
}
