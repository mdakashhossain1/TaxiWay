import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';

/// One realtime snapshot of an active trip, as written by the driver app and
/// pushed to the rider over Firestore. Every field is nullable because a live
/// document is built up incrementally — the driver may have published a status
/// before the first GPS fix, or vice versa.
class TripLiveUpdate {
  final BookingStatus? status;
  final double? driverLat;
  final double? driverLng;
  final double? driverHeading;

  /// 0..1 progress along the route while the ride is in progress, reported by
  /// the driver app when it has a real routed position. Null before the ride
  /// starts.
  final double? routeProgress;
  final DateTime? updatedAt;

  const TripLiveUpdate({
    this.status,
    this.driverLat,
    this.driverLng,
    this.driverHeading,
    this.routeProgress,
    this.updatedAt,
  });

  bool get hasDriverLocation => driverLat != null && driverLng != null;

  bool get isEmpty =>
      status == null && driverLat == null && driverLng == null && routeProgress == null;
}

/// Reads the live trip feed the driver app publishes. Abstract so the Firestore
/// transport can be swapped (e.g. for a Laravel websocket) without touching the
/// booking controller or any screen.
abstract class TripChannel {
  /// A broadcast stream of updates for one booking. Emits every time the
  /// driver app writes a new position or status; completes nothing on its own.
  Stream<TripLiveUpdate> watch(String bookingId);
}

class FirestoreTripChannel implements TripChannel {
  static const collection = 'live_trips';

  // Firestore's .snapshots() opens a fresh listener per call, so cache by
  // bookingId to keep the stream identity stable across rebuilds — same reason
  // FirebaseChatRepository caches its message streams.
  final Map<String, Stream<TripLiveUpdate>> _streams = {};

  @override
  Stream<TripLiveUpdate> watch(String bookingId) {
    return _streams.putIfAbsent(
      bookingId,
      () => FirebaseFirestore.instance
          .collection(collection)
          .doc(bookingId)
          .snapshots()
          .map(_toUpdate)
          .asBroadcastStream(),
    );
  }

  TripLiveUpdate _toUpdate(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) return const TripLiveUpdate();
    final statusName = data['status'] as String?;
    return TripLiveUpdate(
      status: statusName == null ? null : bookingStatusFromApi(statusName),
      driverLat: (data['driverLat'] as num?)?.toDouble(),
      driverLng: (data['driverLng'] as num?)?.toDouble(),
      driverHeading: (data['driverHeading'] as num?)?.toDouble(),
      routeProgress: (data['routeProgress'] as num?)?.toDouble(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}

final tripChannelProvider = Provider<TripChannel>((ref) => FirestoreTripChannel());
