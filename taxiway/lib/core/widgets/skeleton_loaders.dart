import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'app_shimmer.dart';

class VehicleOptionSkeleton extends StatelessWidget {
  const VehicleOptionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final type = AppTypography.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: Colors.transparent, width: 2),
      ),
      child: AppShimmer(
        child: Row(
          children: [
            const ShimmerBox(width: 84, height: 52, borderRadius: AppRadius.medium),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(style: type.label.copyWith(fontSize: 17), width: 96),
                  const SizedBox(height: 2),
                  ShimmerText(style: type.caption, width: 54),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ShimmerText(style: type.h3.copyWith(fontSize: 18), width: 52),
          ],
        ),
      ),
    );
  }
}

class VehicleOptionListSkeleton extends StatelessWidget {
  final int count;

  const VehicleOptionListSkeleton({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (_, _) => const VehicleOptionSkeleton(),
    );
  }
}

class TripCardSkeleton extends StatelessWidget {
  const TripCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final type = AppTypography.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
      ),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ShimmerBox(width: 44, height: 32, borderRadius: 6),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerText(style: type.label, width: 84),
                      ShimmerText(style: type.caption.copyWith(fontSize: 13), width: 112),
                    ],
                  ),
                ),
                const ShimmerBox(width: 78, height: 28, borderRadius: AppRadius.pill),
              ],
            ),
            const SizedBox(height: 12),
            _stop(type, 150),
            const SizedBox(height: 14),
            _stop(type, 210),
            const SizedBox(height: 12),
            const ShimmerBox(height: 1, borderRadius: 0),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerText(style: type.caption, width: 92),
                ShimmerText(style: type.h3.copyWith(fontSize: 16), width: 56),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stop(AppTypographyExtension type, double width) {
    return Row(
      children: [
        const ShimmerCircle(size: 9),
        const SizedBox(width: 10),
        ShimmerText(style: type.body, width: width),
      ],
    );
  }
}

class TripListSkeleton extends StatelessWidget {
  final int count;

  const TripListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => const TripCardSkeleton(),
    );
  }
}
