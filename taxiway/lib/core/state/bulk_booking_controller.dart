import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bulk_offer_repository.dart';
import '../models/bulk_booking.dart';
import 'bulk_booking_draft_controller.dart';

class BulkBookingState {
  final BulkBookingRequest? request;
  final BulkOffer? offer;

  const BulkBookingState({this.request, this.offer});

  BulkBookingState copyWith({BulkBookingRequest? request, BulkOffer? offer}) {
    return BulkBookingState(request: request ?? this.request, offer: offer ?? this.offer);
  }
}

/// Simulates operations reviewing a bulk request and preparing an offer:
/// submitted -> (2.5s) under_review -> (4s) offer_ready.
class BulkBookingController extends Notifier<BulkBookingState> {
  final BulkOfferRepository _offerRepo;
  BulkBookingController(this._offerRepo);

  final List<Timer> _timers = [];

  @override
  BulkBookingState build() => const BulkBookingState();

  BulkBookingRequest submitRequest(BulkBookingDraft draft) {
    _cancelTimers();
    final perVehicleEstimate = 800.0 * draft.numVehicles;
    final request = BulkBookingRequest(
      id: _generateRequestId(),
      tripType: draft.tripType,
      pickup: draft.pickup!,
      destination: draft.destination!,
      journeyDate: draft.journeyDate!,
      journeyTime: draft.journeyTime!,
      numVehicles: draft.numVehicles,
      approxPassengers: draft.approxPassengers,
      requirements: draft.requirements,
      notes: draft.notes,
      contactName: draft.contactName,
      contactPhone: draft.contactPhone,
      estimatedFareMin: (perVehicleEstimate * 0.9 / 100).round() * 100,
      estimatedFareMax: (perVehicleEstimate * 1.1 / 100).round() * 100,
      status: BulkBookingStatus.submitted,
      createdAt: DateTime.now(),
    );
    state = BulkBookingState(request: request);

    _timers.add(Timer(const Duration(milliseconds: 2500), () {
      final r = state.request;
      if (r == null) return;
      state = state.copyWith(request: r.copyWith(status: BulkBookingStatus.underReview));

      _timers.add(Timer(const Duration(seconds: 4), () {
        final current = state.request;
        if (current == null) return;
        final offer = _offerRepo.buildOffer(
          numVehicles: current.numVehicles,
          totalFare: (current.estimatedFareMin + current.estimatedFareMax) / 2,
          requirements: current.requirements,
        );
        state = BulkBookingState(
          request: current.copyWith(status: BulkBookingStatus.offerReady),
          offer: offer,
        );
      }));
    }));

    return request;
  }

  void confirmOffer() {
    final r = state.request;
    if (r == null) return;
    state = state.copyWith(request: r.copyWith(status: BulkBookingStatus.confirmed));
  }

  void _cancelTimers() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
  }

  void clear() {
    _cancelTimers();
    state = const BulkBookingState();
  }
}

int _requestCounter = 100;

String _generateRequestId() {
  _requestCounter++;
  final now = DateTime.now();
  final y = now.year.toString();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return 'BK$y$m$d$_requestCounter';
}
