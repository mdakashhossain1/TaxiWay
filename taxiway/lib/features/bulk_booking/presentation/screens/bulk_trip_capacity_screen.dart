import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/bulk_booking.dart';
import '../../../../core/models/place_location.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_calendar_picker.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/location_card.dart';
import '../../../../core/widgets/number_stepper.dart';
import '../../../../core/widgets/ride_map_view.dart';

class BulkTripCapacityScreen extends ConsumerWidget {
  const BulkTripCapacityScreen({super.key});

  Future<void> _pickPickup(BuildContext context, WidgetRef ref) async {
    final result = await context.push<PlaceLocation>(AppRoutes.pickupSearch);
    if (result != null) {
      ref.read(bulkBookingDraftControllerProvider.notifier).setPickup(result);
    }
  }

  Future<void> _pickDestination(BuildContext context, WidgetRef ref) async {
    final result = await context.push<PlaceLocation>(AppRoutes.destinationSearch);
    if (result != null) {
      ref.read(bulkBookingDraftControllerProvider.notifier).setDestination(result);
    }
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final picked = await showAnimatedCalendarPicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(bulkBookingDraftControllerProvider.notifier).setJourneyDate(picked);
    }
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
    if (picked != null && context.mounted) {
      ref.read(bulkBookingDraftControllerProvider.notifier).setJourneyTime(picked.format(context));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bulkBookingDraftControllerProvider);
    final notifier = ref.read(bulkBookingDraftControllerProvider.notifier);
    final defaultPickup = ref.watch(bookingDraftControllerProvider).pickup ??
        const PlaceLocation(
          latitude: 12.9352,
          longitude: 77.6245,
          address: 'Koramangala 5th Block, Bengaluru',
        );
    final userPickup = draft.pickup ?? defaultPickup;

    return AppScaffold(
      appBar: AppBar(title: const Text('Bulk Booking')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Road Route Map Preview
          RideMapView(
            pickup: userPickup,
            destination: draft.destination,
            showDestination: draft.destination != null,
            height: 220,
            borderRadius: BorderRadius.circular(AppRadius.card),
            distanceKm: draft.distanceKm,
            etaMinutes: draft.etaMinutes,
            enableExpand: false,
            interactive: true,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _TripTypeTab(
                  label: 'One Way',
                  selected: draft.tripType == BulkTripType.oneWay,
                  onTap: () => notifier.setTripType(BulkTripType.oneWay),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TripTypeTab(
                  label: 'Round Trip',
                  selected: draft.tripType == BulkTripType.roundTrip,
                  onTap: () => notifier.setTripType(BulkTripType.roundTrip),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LocationCard(
            pickup: userPickup,
            destination: draft.destination,
            onTapPickup: () => _pickPickup(context, ref),
            onTapDestination: () => _pickDestination(context, ref),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _DateTimeField(
                  label: 'Journey Date',
                  value: draft.journeyDate == null ? 'Select date' : DateFormat('dd MMM yyyy').format(draft.journeyDate!),
                  icon: BootstrapIcons.calendar_event,
                  onTap: () => _pickDate(context, ref),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateTimeField(
                  label: 'Journey Time',
                  value: draft.journeyTime ?? 'Select time',
                  icon: BootstrapIcons.clock,
                  onTap: () => _pickTime(context, ref),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: NumberStepper(
                  label: 'Number of Vehicles',
                  value: draft.numVehicles,
                  onChanged: notifier.setNumVehicles,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NumberStepper(
                  label: 'Approx. Passengers',
                  value: draft.approxPassengers,
                  onChanged: notifier.setApproxPassengers,
                  max: 200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Continue',
            onPressed: draft.step1Valid ? () => context.push(AppRoutes.bulkAdditionalRequirements) : null,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TripTypeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TripTypeTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBackground : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(color: selected ? AppColors.primaryDark : AppColors.navy),
        ),
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  const _DateTimeField({required this.label, required this.value, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label),
          const SizedBox(height: 8),
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.mutedText),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: AppTypography.body.copyWith(color: AppColors.navy), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
