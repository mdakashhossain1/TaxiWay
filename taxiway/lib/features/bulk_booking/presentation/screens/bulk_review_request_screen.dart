import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/bulk_booking.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/utils/geo_utils.dart';

class BulkReviewRequestScreen extends ConsumerWidget {
  const BulkReviewRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bulkBookingDraftControllerProvider);
    final perVehicle = 800.0 * draft.numVehicles;
    final fareMin = (perVehicle * 0.9 / 100).round() * 100;
    final fareMax = (perVehicle * 1.1 / 100).round() * 100;

    return AppScaffold(
      appBar: AppBar(title: const Text('Review Request')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (draft.pickup != null && draft.destination != null) ...[
            RideMapView(
              pickup: draft.pickup,
              destination: draft.destination,
              showDestination: true,
              height: 180,
              borderRadius: BorderRadius.circular(AppRadius.card),
              distanceKm: draft.distanceKm,
              etaMinutes: draft.etaMinutes,
              interactive: false,
              enableExpand: false,
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).card, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.of(context).border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row('From', draft.pickup?.address ?? '-'),
                _Row('To', draft.destination?.address ?? '-'),
                _Row('Date', draft.journeyDate == null ? '-' : DateFormat('dd MMM yyyy').format(draft.journeyDate!)),
                _Row('Time', draft.journeyTime ?? '-'),
                _Row('Trip Type', draft.tripType == BulkTripType.oneWay ? 'One Way' : 'Round Trip'),
                _Row('Vehicles', '${draft.numVehicles}'),
                _Row('Passengers', '${draft.approxPassengers}'),
                if (draft.requirements.isNotEmpty) _Row('Requirements', draft.requirements.join(', ')),
                if (draft.notes.trim().isNotEmpty) _Row('Notes', draft.notes.trim()),
                _Row('Contact', '${draft.contactName} · ${draft.contactPhone}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).primaryBackground, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated Fare Range', style: AppTypography.of(context).label),
                const SizedBox(height: 6),
                Text(
                  '${formatRupees(fareMin)} – ${formatRupees(fareMax)}',
                  style: AppTypography.of(context).price.copyWith(color: AppColors.of(context).primaryDark),
                ),
                const SizedBox(height: 8),
                Text('Estimated only. Final offer may vary after vehicle confirmation.', style: AppTypography.of(context).caption),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Submit Request',
            onPressed: () {
              ref.read(bulkBookingControllerProvider.notifier).submitRequest(draft);
              ref.read(bulkBookingDraftControllerProvider.notifier).reset();
              AppToast.success(context, 'Bulk booking request submitted for review!', title: 'Request Sent');
              context.push(AppRoutes.bulkRequestSubmitted);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTypography.of(context).caption)),
          Expanded(child: Text(value, style: AppTypography.of(context).label, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
