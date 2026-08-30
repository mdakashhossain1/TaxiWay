import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/driver_card.dart';
import '../../../../core/widgets/rating_stars.dart';

class FullDriverProfileScreen extends ConsumerWidget {
  const FullDriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(currentDriverProvider);
    final distribution = ref.watch(ratingDistributionProvider);
    final reviews = ref.watch(reviewsProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Driver Profile & Reviews')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const DriverAvatar(size: 68),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.name, style: AppTypography.of(context).h2),
                    const SizedBox(height: 4),
                    Text('${driver.languages.join(', ')} · ${driver.operatingArea}', style: AppTypography.of(context).caption),
                    Text('Member since ${driver.memberSince}', style: AppTypography.of(context).caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _AboutStat(value: driver.rating.toStringAsFixed(1), label: 'Rating'),
              _AboutStat(value: '${driver.totalTrips}', label: 'Total Trips'),
              _AboutStat(value: '${driver.yearsExperience}+', label: 'Years Exp.'),
            ],
          ),
          const SizedBox(height: 20),
          Text('About Driver', style: AppTypography.of(context).h3),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).border),
            ),
            child: Column(
              children: [
                _InfoRow('Name', driver.name),
                _InfoRow('Languages', driver.languages.join(', ')),
                _InfoRow('Lives In', driver.operatingArea),
                _InfoRow('Member Since', driver.memberSince),
                _VerifyRow('Driving License', driver.licenceVerified),
                _VerifyRow('Identity Verified', driver.identityVerified),
                _VerifyRow('Background Check', driver.backgroundChecked),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Rating Distribution', style: AppTypography.of(context).h3),
          const SizedBox(height: 12),
          Column(
            children: [
              for (var i = 0; i < distribution.percentageByStar.length; i++)
                _RatingBar(stars: 5 - i, percent: distribution.percentageByStar[i]),
            ],
          ),
          const SizedBox(height: 20),
          Text('Reviews', style: AppTypography.of(context).h3),
          const SizedBox(height: 10),
          if (reviews.isEmpty)
            Text("No reviews yet.", style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).mutedText))
          else
            Column(
              children: reviews.map((r) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.of(context).surface, borderRadius: BorderRadius.circular(AppRadius.medium)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r.reviewerName, style: AppTypography.of(context).label),
                          Text(r.relativeDate, style: AppTypography.of(context).caption),
                        ],
                      ),
                      const SizedBox(height: 4),
                      RatingStars(rating: r.rating, size: 14),
                      const SizedBox(height: 8),
                      Text(r.comment, style: AppTypography.of(context).body),
                    ],
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AboutStat extends StatelessWidget {
  final String value;
  final String label;
  const _AboutStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: AppTypography.of(context).h2),
          Text(label, style: AppTypography.of(context).caption),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText)),
              Flexible(
                child: Text(
                  value,
                  style: AppTypography.of(context).label.copyWith(color: AppColors.of(context).navy, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: AppColors.of(context).border),
      ],
    );
  }
}

class _VerifyRow extends StatelessWidget {
  final String label;
  final bool verified;
  const _VerifyRow(this.label, this.verified);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).mutedText)),
          Row(
            children: [
              Icon(
                verified ? BootstrapIcons.check_circle_fill : BootstrapIcons.x_circle_fill,
                size: 14,
                color: verified ? AppColors.of(context).success : AppColors.of(context).warningText,
              ),
              const SizedBox(width: 4),
              Text(
                verified ? 'Verified' : 'Pending',
                style: AppTypography.of(context).label.copyWith(color: verified ? AppColors.of(context).success : AppColors.of(context).warningText, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final int stars;
  final int percent;
  const _RatingBar({required this.stars, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 26, child: Text('$stars★', style: AppTypography.of(context).caption)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percent / 100),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: AppColors.of(context).surface,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFF59E0B)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 34, child: Text('$percent%', style: AppTypography.of(context).caption)),
        ],
      ),
    );
  }
}
