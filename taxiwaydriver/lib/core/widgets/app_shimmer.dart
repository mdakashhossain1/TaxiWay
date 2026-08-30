import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Base shimmer container providing consistent lighting and speed.
class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: baseColor ?? (isDark ? AppColors.of(context).surface : const Color(0xFFE2E8F0)),
      highlightColor: highlightColor ?? (isDark ? AppColors.of(context).border : const Color(0xFFF8FAFC)),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

/// A rectangular skeleton box with rounded corners.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A circular skeleton placeholder (for avatars, icons, buttons).
class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({
    super.key,
    required this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// A skeleton text line with rounded pill ends.
class ShimmerLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerLine({
    super.key,
    this.width,
    this.height = 12,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

/// Shimmer layout for list of rides / bookings.
class RideListShimmer extends StatelessWidget {
  final int itemCount;

  const RideListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.of(context).border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ShimmerLine(width: 130, height: 14),
                  ShimmerBox(width: 60, height: 22, borderRadius: 6),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: const [
                      ShimmerCircle(size: 10),
                      SizedBox(height: 4),
                      ShimmerBox(width: 2, height: 20),
                      SizedBox(height: 4),
                      ShimmerCircle(size: 10),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerLine(width: double.infinity, height: 12),
                        SizedBox(height: 16),
                        ShimmerLine(width: 180, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: AppColors.of(context).border),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ShimmerLine(width: 90, height: 12),
                  ShimmerLine(width: 70, height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer layout for vehicle category selection in booking flow.
class VehicleSelectionShimmer extends StatelessWidget {
  const VehicleSelectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).border),
            ),
            child: Row(
              children: const [
                ShimmerBox(width: 72, height: 50, borderRadius: 10),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLine(width: 100, height: 15),
                      SizedBox(height: 6),
                      ShimmerLine(width: 140, height: 11),
                      SizedBox(height: 6),
                      ShimmerLine(width: 70, height: 10),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerLine(width: 55, height: 16),
                    SizedBox(height: 6),
                    ShimmerLine(width: 40, height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer layout for driver dashboard metrics and subscription status.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ShimmerLine(width: 120, height: 20),
                ShimmerCircle(size: 40),
              ],
            ),
            const SizedBox(height: 16),

            // Profile info row
            Row(
              children: const [
                ShimmerCircle(size: 48),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLine(width: 140, height: 16),
                    SizedBox(height: 6),
                    ShimmerLine(width: 90, height: 12),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Big Subscription / Revenue Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.of(context).border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerLine(width: 90, height: 12),
                  SizedBox(height: 8),
                  ShimmerLine(width: 160, height: 26),
                  SizedBox(height: 16),
                  ShimmerBox(width: double.infinity, height: 8, borderRadius: 4),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerLine(width: 80, height: 14),
                      ShimmerLine(width: 80, height: 14),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2-card metric grid
            Row(
              children: const [
                Expanded(child: ShimmerBox(height: 90, borderRadius: 16)),
                SizedBox(width: 12),
                Expanded(child: ShimmerBox(height: 90, borderRadius: 16)),
              ],
            ),
            const SizedBox(height: 24),

            // Next ride section
            const ShimmerLine(width: 110, height: 18),
            const SizedBox(height: 12),
            const ShimmerBox(width: double.infinity, height: 130, borderRadius: 16),
          ],
        ),
      ),
    );
  }
}

/// Generic page skeleton with header, summary card, and list items.
class GeneralPageShimmer extends StatelessWidget {
  const GeneralPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerLine(width: 160, height: 22),
            SizedBox(height: 8),
            ShimmerLine(width: 240, height: 13),
            SizedBox(height: 24),
            ShimmerBox(width: double.infinity, height: 110, borderRadius: 16),
            SizedBox(height: 20),
            ShimmerLine(width: 120, height: 16),
            SizedBox(height: 12),
            ShimmerBox(width: double.infinity, height: 64, borderRadius: 12),
            SizedBox(height: 10),
            ShimmerBox(width: double.infinity, height: 64, borderRadius: 12),
            SizedBox(height: 10),
            ShimmerBox(width: double.infinity, height: 64, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
