import 'package:flutter/material.dart';
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
    final distText = distanceKm != null ? ' (${distanceKm!.toStringAsFixed(1)} km)' : '';
    final timeText = etaMinutes != null ? ' ($etaMinutes min)' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
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
              _FareItem(label: 'Base Fare', value: '₹${fare.baseFare.toInt()}'),
              const Text('+', style: TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.bold)),
              _FareItem(label: 'Distance$distText', value: '₹${fare.distanceFare.toInt()}'),
              const Text('+', style: TextStyle(color: AppColors.mutedText, fontWeight: FontWeight.bold)),
              _FareItem(label: 'Time$timeText', value: '₹${fare.timeFare.toInt()}'),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          Text(
            'Tolls & parking extra',
            style: AppTypography.caption.copyWith(
              color: AppColors.mutedText,
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
          style: AppTypography.caption.copyWith(
            color: AppColors.mutedText,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
