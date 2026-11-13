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
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../core/widgets/status_badge.dart';
import 'bulk_status_label.dart';
import '../../../../l10n/generated/app_localizations.dart';

class BulkRequestDetailsScreen extends ConsumerWidget {
  const BulkRequestDetailsScreen({super.key});

  void _handleTransition(BuildContext context, BulkBookingStatus status) {
    if (!context.mounted) return;
    if (status == BulkBookingStatus.offerReady) {
      context.pushReplacement(AppRoutes.bulkOffersReceived);
    }
  }

  BadgeVariant _variant(BulkBookingStatus status) {
    switch (status) {
      case BulkBookingStatus.offerReady:
      case BulkBookingStatus.confirmed:
        return BadgeVariant.verified;
      case BulkBookingStatus.cancelled:
        return BadgeVariant.cancelled;
      default:
        return BadgeVariant.pending;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(bulkBookingControllerProvider).request;

    ref.listen(bulkBookingControllerProvider, (previous, next) {
      if (next.request != null) _handleTransition(context, next.request!.status);
    });

    if (request == null) {
      return AppScaffold(appBar: AppBar(), body: Center(child: Text(AppLocalizations.of(context).noRequestFound)));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _handleTransition(context, request.status));

    return AppScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).bulkRequestTitle)),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(request.id, style: AppTypography.of(context).h3),
              StatusBadge(label: bulkStatusLabel(request.status), variant: _variant(request.status)),
            ],
          ),
          Text(DateFormat('dd MMM yyyy, hh:mm a').format(request.createdAt), style: AppTypography.of(context).caption),
          const SizedBox(height: 16),
          RideMapView(
            pickup: request.pickup,
            destination: request.destination,
            showDestination: true,
            height: 180,
            borderRadius: BorderRadius.circular(AppRadius.card),
            interactive: false,
            enableExpand: false,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).card, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.of(context).border)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Row(AppLocalizations.of(context).fromLabel, request.pickup.address),
                _Row(AppLocalizations.of(context).toLabel, request.destination.address),
                _Row(AppLocalizations.of(context).dateLabel, DateFormat('dd MMM yyyy').format(request.journeyDate)),
                _Row(AppLocalizations.of(context).timeLabel, request.journeyTime),
                _Row(AppLocalizations.of(context).vehiclesLabel, '${request.numVehicles}'),
                _Row(AppLocalizations.of(context).passengersLabel, '${request.approxPassengers}'),
                if (request.requirements.isNotEmpty) _Row(AppLocalizations.of(context).requirementsLabel, request.requirements.join(', ')),
                _Row(AppLocalizations.of(context).contactLabel, '${request.contactName} · ${request.contactPhone}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).surface, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.of(context).primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).arrangingVehiclesNote,
                    style: AppTypography.of(context).body,
                  ),
                ),
              ],
            ),
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
