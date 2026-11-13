import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'app_shimmer.dart';

class DriverRideCardSkeleton extends StatelessWidget {
  const DriverRideCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final type = AppTypography.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: AppShimmer(
        onSurface: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(
              width: 58,
              height: 20 + (type.h2.height ?? 1) * 22 + (type.caption.height ?? 1) * (type.caption.fontSize ?? 16),
              borderRadius: AppRadius.medium,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerText(style: type.label, width: 72),
                      const ShimmerBox(width: 82, height: 28, borderRadius: AppRadius.pill),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _stop(type, 170),
                  const SizedBox(height: 12),
                  _stop(type, 210),
                  const SizedBox(height: 12),
                  ShimmerText(style: type.h3, width: 64),
                ],
              ),
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

class DriverRideListSkeleton extends StatelessWidget {
  final int count;

  const DriverRideListSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (context, index) => const DriverRideCardSkeleton(),
    );
  }
}

class SubscriptionCardSkeleton extends StatelessWidget {
  const SubscriptionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final type = AppTypography.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: AppShimmer(
        onSurface: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerText(style: type.label, width: 96),
            const SizedBox(height: 4),
            ShimmerText(style: type.priceLarge, width: 200),
            ShimmerText(style: type.body, width: 130),
            const SizedBox(height: 14),
            const ShimmerBox(height: 10, borderRadius: 5),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerText(style: type.priceLarge, width: 44),
                    ShimmerText(style: type.caption, width: 72),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerText(style: type.priceLarge, width: 44, alignment: Alignment.centerRight),
                    ShimmerText(style: type.caption, width: 96, alignment: Alignment.centerRight),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            ShimmerText(style: type.caption, width: 170),
          ],
        ),
      ),
    );
  }
}

class NextRideCardSkeleton extends StatelessWidget {
  const NextRideCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final type = AppTypography.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: AppShimmer(
        onSurface: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerText(style: type.label, width: 150),
            const SizedBox(height: 12),
            _stop(type, 190),
            const SizedBox(height: 14),
            _stop(type, 230),
            const SizedBox(height: 12),
            const ShimmerBox(height: 1, borderRadius: 0),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerText(style: type.body, width: 140),
                ShimmerText(style: type.body, width: 64),
              ],
            ),
            const SizedBox(height: 6),
            ShimmerText(style: type.h3, width: 150),
            const SizedBox(height: 16),
            const ShimmerBox(height: 54, borderRadius: AppRadius.button),
            const SizedBox(height: 10),
            const ShimmerBox(height: 54, borderRadius: AppRadius.button),
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

class SubscriptionScreenSkeleton extends StatelessWidget {
  const SubscriptionScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final type = AppTypography.of(context);
    final surface = AppColors.of(context).surface;

    Widget metric() => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(color: surface, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: AppShimmer(
              onSurface: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerText(style: type.price.copyWith(fontSize: 24), width: 84),
                  const SizedBox(height: 4),
                  ShimmerText(style: type.caption, width: 96),
                ],
              ),
            ),
          ),
        );

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          const SubscriptionCardSkeleton(),
          const SizedBox(height: 20),
          IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [metric(), const SizedBox(width: 12), metric()])),
          const SizedBox(height: 12),
          IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [metric(), const SizedBox(width: 12), metric()])),
        ],
      ),
    );
  }
}
