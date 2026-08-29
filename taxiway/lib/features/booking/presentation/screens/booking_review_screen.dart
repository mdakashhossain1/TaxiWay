import 'package:bootstrap_icons/bootstrap_icons.dart';
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
import '../../../../core/widgets/fare_card.dart';
import '../../../../core/widgets/payment_brand_widgets.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/utils/geo_utils.dart';

class BookingReviewScreen extends ConsumerStatefulWidget {
  const BookingReviewScreen({super.key});

  @override
  ConsumerState<BookingReviewScreen> createState() => _BookingReviewScreenState();
}

class _BookingReviewScreenState extends ConsumerState<BookingReviewScreen> {
  String _selectedPaymentMethod = 'cash';

  String _imageForCategory(String id) {
    switch (id) {
      case 'hatchback':
        return 'assets/images/car_hatchback.jpg';
      case 'suv':
        return 'assets/images/car_suv.jpg';
      case 'traveller':
      case 'tempo':
        return 'assets/images/car_traveller.jpg';
      case 'sedan':
      default:
        return 'assets/images/car_sedan.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bookingDraftControllerProvider);
    final category = draft.selectedCategory;
    final fare = category != null ? ref.read(bookingDraftControllerProvider.notifier).fareFor(category) : null;

    if (!draft.hasRoute || category == null || fare == null) {
      return AppScaffold(appBar: AppBar(), body: const Center(child: Text('Missing booking details.')));
    }

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Confirm your ride',
          style: AppTypography.h2.copyWith(fontSize: 18, color: AppColors.navy),
        ),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Route Preview
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: RideMapView(
              pickup: draft.pickup,
              destination: draft.destination,
              showDestination: true,
              height: 180,
            ),
          ),
          const SizedBox(height: 18),

          // Selected Vehicle Hero Card
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: Container(
                    width: 88,
                    height: 64,
                    color: const Color(0xFFF8FAFC),
                    child: Image.asset(
                      _imageForCategory(category.id),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: AppTypography.h2.copyWith(fontSize: 18, color: AppColors.navy),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${category.seats} Seats',
                              style: AppTypography.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBackground,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'AC',
                              style: AppTypography.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  formatRupees(fare.total),
                  style: AppTypography.h2.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Route Details Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _RouteLine(label: draft.pickup!.address, isPickup: true),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: SizedBox(
                    height: 18,
                    child: VerticalDivider(width: 1, thickness: 1.5, color: Color(0xFFCBD5E1)),
                  ),
                ),
                _RouteLine(label: draft.destination!.address, isPickup: false),
                const SizedBox(height: 12),
                Container(height: 1, color: AppColors.border),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trip Distance: ${draft.distanceKm.toStringAsFixed(1)} km',
                      style: AppTypography.caption.copyWith(color: AppColors.bodyText),
                    ),
                    Text(
                      'Est. Time: ${draft.etaMinutes} min',
                      style: AppTypography.caption.copyWith(color: AppColors.bodyText),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Fare Card
          FareCard(fare: fare),

          const SizedBox(height: 18),

          // Payment Method Selector
          Text(
            'Payment Method',
            style: AppTypography.h3.copyWith(fontSize: 16, color: AppColors.navy),
          ),
          const SizedBox(height: 10),

          // Real Brand Payment Options
          Column(
            children: [
              ModernPaymentOptionTile(
                id: 'upi',
                title: 'UPI (GPay, PhonePe, Paytm)',
                subtitle: 'Pay directly via any UPI app / QR code',
                logo: const UpiLogoWidget(height: 18),
                selected: _selectedPaymentMethod == 'upi',
                onTap: () => setState(() => _selectedPaymentMethod = 'upi'),
              ),
              const SizedBox(height: 10),
              ModernPaymentOptionTile(
                id: 'cash',
                title: 'Cash Payment',
                subtitle: 'Pay driver directly after completing the trip',
                logo: const CashLogoWidget(size: 18),
                selected: _selectedPaymentMethod == 'cash',
                onTap: () => setState(() => _selectedPaymentMethod = 'cash'),
              ),
              const SizedBox(height: 10),
              ModernPaymentOptionTile(
                id: 'card',
                title: 'Credit / Debit Card',
                subtitle: 'Visa, MasterCard, RuPay, Corporate cards',
                logo: const CardBrandLogoWidget(height: 18),
                selected: _selectedPaymentMethod == 'card',
                onTap: () => setState(() => _selectedPaymentMethod = 'card'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Confirm Booking Primary CTA Button
          PrimaryButton(
            label: 'Confirm Booking — ${formatRupees(fare.total)}',
            onPressed: () async {
              context.push(AppRoutes.bookingProcessing);
              try {
                await ref.read(bookingControllerProvider.notifier).createBooking(
                      pickup: draft.pickup!,
                      destination: draft.destination!,
                      vehicleCategory: category,
                      distanceKm: draft.distanceKm,
                      etaMinutes: draft.etaMinutes,
                      fare: fare,
                    );
              } catch (_) {
                if (!context.mounted) return;
                context.pop();
                AppToast.error(context, "Couldn't complete booking right now. Please try again.", title: 'Booking Failed');
              }
            },
          ),

          const SizedBox(height: 10),
          AppOutlineButton(
            label: 'Change Vehicle',
            onPressed: () => context.pop(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _RouteLine extends StatelessWidget {
  final String label;
  final bool isPickup;
  const _RouteLine({required this.label, required this.isPickup});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: isPickup
              ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle))
              : const Icon(BootstrapIcons.geo_alt_fill, color: AppColors.primary, size: 14),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.navy),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
