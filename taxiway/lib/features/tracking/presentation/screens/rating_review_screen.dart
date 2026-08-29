import 'package:flutter/material.dart';
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

const _quickTags = ['Clean Car', 'Safe Driving', 'Polite', 'On Time', 'Good AC', 'Comfortable'];
const _tips = [10, 20, 50, 100];

class RatingReviewScreen extends ConsumerStatefulWidget {
  const RatingReviewScreen({super.key});

  @override
  ConsumerState<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends ConsumerState<RatingReviewScreen> {
  int _rating = 5;
  final Set<String> _selectedTags = {};
  int? _selectedTip;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final booking = ref.read(bookingControllerProvider);
    if (booking != null) {
      try {
        await ref.read(reviewRepositoryProvider).submitReview(
              bookingId: booking.id,
              rating: _rating,
              comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
              tags: _selectedTags.toList(),
            );
      } catch (_) {
        // Non-fatal — the ride is already complete either way; the
        // customer isn't blocked from moving on if the review fails to save.
      }
      ref.read(tripHistoryControllerProvider.notifier).refresh();
      ref.read(bookingControllerProvider.notifier).clear();
    }
    ref.read(bookingDraftControllerProvider.notifier).reset();
    if (!mounted) return;
    AppToast.success(context, 'Thank you for rating your ride!', title: 'Feedback Submitted');
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final driver = ref.watch(currentDriverProvider);

    return AppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Rate & Review', style: AppTypography.h2.copyWith(fontSize: 18, color: AppColors.navy)),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),

          // Driver Avatar
          const DriverAvatar(size: 72),
          const SizedBox(height: 12),

          Text(
            'How was your ride?',
            style: AppTypography.h1.copyWith(fontSize: 22, color: AppColors.navy),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'with ${driver.name}',
            style: AppTypography.body.copyWith(color: AppColors.bodyText),
          ),
          const SizedBox(height: 20),

          // 5-Star Interactive Rating
          InteractiveRatingStars(
            value: _rating,
            onChanged: (v) => setState(() => _rating = v),
          ),

          const SizedBox(height: 24),

          // Feedback Tags
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What went well?',
              style: AppTypography.h3.copyWith(fontSize: 15, color: AppColors.navy),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickTags.map((tag) {
                final selected = _selectedTags.contains(tag);
                return ChoiceChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (v) => setState(() => v ? _selectedTags.add(tag) : _selectedTags.remove(tag)),
                  labelStyle: AppTypography.label.copyWith(
                    color: selected ? AppColors.primaryDark : AppColors.navy,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  selectedColor: AppColors.primaryBackground,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: selected ? AppColors.primary : const Color(0xFFCBD5E1),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Tip Driver (Optional)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Add a Tip (Optional)',
              style: AppTypography.h3.copyWith(fontSize: 15, color: AppColors.navy),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: _tips.map((tip) {
              final isSelected = _selectedTip == tip;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => _selectedTip = isSelected ? null : tip),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryBackground : Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '₹$tip',
                          style: AppTypography.label.copyWith(
                            color: isSelected ? AppColors.primaryDark : AppColors.navy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Comments
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Leave a note for the driver (optional)...',
            ),
          ),

          const SizedBox(height: 28),

          PrimaryButton(
            label: 'Submit Review',
            onPressed: _rating > 0 ? _submit : null,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
