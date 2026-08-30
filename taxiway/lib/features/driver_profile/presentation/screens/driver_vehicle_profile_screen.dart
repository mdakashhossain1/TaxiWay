import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/driver_card.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/widgets/vehicle_media_placeholder.dart';

class DriverVehicleProfileScreen extends ConsumerWidget {
  const DriverVehicleProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(currentDriverProvider);
    final vehicle = ref.watch(currentVehicleProvider);
    final reviews = ref.watch(reviewsProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text('Driver & Vehicle', style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy)),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Driver Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // Intentionally fixed dark navy in both themes — the hero
              // card's white text is designed for a dark backdrop, unlike
              // AppColors.navy which flips to near-white in dark mode.
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Column(
              children: [
                const DriverAvatar(size: 76),
                const SizedBox(height: 12),
                Text(driver.name, style: AppTypography.of(context).h2.copyWith(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(BootstrapIcons.patch_check_fill, size: 15, color: AppColors.of(context).success),
                    const SizedBox(width: 4),
                    Text('Verified Driver · Online', style: AppTypography.of(context).caption.copyWith(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatColumn(value: driver.rating.toStringAsFixed(1), label: 'Rating', icon: BootstrapIcons.star_fill),
                    _StatColumn(value: '${driver.totalTrips}', label: 'Trips'),
                    _StatColumn(value: '${driver.completionRate}%', label: 'Completion'),
                    _StatColumn(value: '${driver.yearsExperience}+ yrs', label: 'Experience'),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.05, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),

          const SizedBox(height: 20),

          Text('Verification', style: AppTypography.of(context).h3.copyWith(fontSize: 16, color: AppColors.of(context).navy)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).border),
            ),
            child: Column(
              children: [
                _VerificationRow(label: 'Identity Verified', verified: driver.identityVerified),
                Divider(height: 14, color: AppColors.of(context).border),
                _VerificationRow(label: 'Driving Licence Verified', verified: driver.licenceVerified),
                Divider(height: 14, color: AppColors.of(context).border),
                _VerificationRow(label: 'Background Checked', verified: driver.backgroundChecked),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text('Assigned Vehicle', style: AppTypography.of(context).h3.copyWith(fontSize: 16, color: AppColors.of(context).navy)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset('assets/images/car_sedan.jpg', fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vehicle.model, style: AppTypography.of(context).h3.copyWith(fontSize: 16, color: AppColors.of(context).navy)),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.of(context).primaryBackground,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              vehicle.registrationNumber,
                              style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).primaryDark, fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Chip(vehicle.category),
                    _Chip('${vehicle.seats} Seater'),
                    if (vehicle.ac) const _Chip('AC'),
                    _Chip(vehicle.fuelType),
                    if (vehicle.nonSmoking) const _Chip('Non-Smoking'),
                    if (vehicle.gps) const _Chip('GPS Enabled'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Vehicle Photos', style: AppTypography.of(context).h3.copyWith(fontSize: 16, color: AppColors.of(context).navy)),
              TextButton(
                onPressed: () => context.push(AppRoutes.vehicleGallery),
                child: Text('View All', style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).primaryDark)),
              ),
            ],
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: vehicle.media.take(4).length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) => SizedBox(
                width: 110,
                child: VehicleMediaTile(media: vehicle.media[i], onTap: () => context.push(AppRoutes.vehicleGallery)),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Passenger Reviews', style: AppTypography.of(context).h3.copyWith(fontSize: 16, color: AppColors.of(context).navy)),
              TextButton(
                onPressed: () => context.push(AppRoutes.fullDriverProfile),
                child: Text('View All', style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).primaryDark)),
              ),
            ],
          ),
          if (reviews.isEmpty)
            Text("No reviews yet.", style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).mutedText))
          else
            Column(
              children: reviews.take(2).map((r) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).card,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(color: AppColors.of(context).border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(r.reviewerName, style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).navy, fontWeight: FontWeight.w600)),
                            RatingStars(rating: r.rating, size: 14),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(r.comment, style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).bodyText, fontSize: 13)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: AppOutlineButton(
                  label: 'Message',
                  icon: BootstrapIcons.chat_dots,
                  onPressed: () => AppToast.info(context, 'Messaging driver Amit Kumar...', title: 'Chat'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Call Driver',
                  icon: BootstrapIcons.telephone_fill,
                  onPressed: () => AppToast.call(context, 'Calling driver Amit Kumar (+91 98765 00000)...', title: 'Phone Call'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  const _StatColumn({required this.value, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: 14, color: const Color(0xFFF59E0B)), const SizedBox(width: 3)],
            Text(value, style: AppTypography.of(context).h3.copyWith(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.of(context).caption.copyWith(color: Colors.white60)),
      ],
    );
  }
}

class _VerificationRow extends StatelessWidget {
  final String label;
  final bool verified;
  const _VerificationRow({required this.label, required this.verified});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            verified ? BootstrapIcons.check_circle_fill : BootstrapIcons.x_circle_fill,
            size: 18,
            color: verified ? AppColors.of(context).success : AppColors.of(context).error,
          ),
          const SizedBox(width: 10),
          Text(label, style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).navy, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.of(context).primaryBorder),
      ),
      child: Text(
        label,
        style: AppTypography.of(context).caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.of(context).primaryDark, fontSize: 11),
      ),
    );
  }
}
