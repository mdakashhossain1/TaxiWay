import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../models/fare_breakdown.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class FareCard extends StatelessWidget {
  final FareBreakdown fare;
  final double? distanceKm;
  final int? etaMinutes;

  const FareCard({
    super.key,
    required this.fare,
    this.distanceKm,
    this.etaMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final distText = distanceKm != null ? ' (${l10n.kmShort(distanceKm!.toStringAsFixed(1))})' : '';
    final timeText = etaMinutes != null ? ' (${l10n.minutesShort(etaMinutes!)})' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.of(context).border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FareItem(label: l10n.baseFareLabel, value: '₹${fare.baseFare.toInt()}'),
              Text('+', style: TextStyle(color: AppColors.of(context).mutedText, fontWeight: FontWeight.bold)),
              _FareItem(label: '${l10n.distanceLabel}$distText', value: '₹${fare.distanceFare.toInt()}'),
              Text('+', style: TextStyle(color: AppColors.of(context).mutedText, fontWeight: FontWeight.bold)),
              _FareItem(label: '${l10n.timeLabel}$timeText', value: '₹${fare.timeFare.toInt()}'),
            ],
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: AppColors.of(context).border),
          const SizedBox(height: 8),
          Text(
            l10n.tollsParkingNote,
            style: AppTypography.of(context).caption.copyWith(
              color: AppColors.of(context).mutedText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _FareItem extends StatelessWidget {
  final String label;
  final String value;

  const _FareItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.of(context).caption.copyWith(
            color: AppColors.of(context).mutedText,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.of(context).body.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.of(context).navy,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
