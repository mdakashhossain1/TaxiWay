import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/place_location.dart';
import 'geo_index.dart';

/// An available driver near the rider, as published to `driver_locations`.
class NearbyDriver {
  final String id;
  final double lat;
  final double lng;
  final double? heading;

  const NearbyDriver({required this.id, required this.lat, required this.lng, this.heading});
}

final geoIndexProvider = FutureProvider<GeoIndex>((_) => GeoIndex.instance());

/// Live available drivers around [center], found by H3 cell + ring — the same
/// hexagonal index Uber uses for driver search. Queries only by cell (an
/// indexed field); availability and staleness are filtered client-side so no
/// Firestore composite index is required. Emits an empty list until H3 loads.
///
/// A document is considered live only if it was updated within [_staleAfter];
/// drivers that go offline without a final write simply age out.
final nearbyDriversProvider =
    StreamProvider.autoDispose.family<List<NearbyDriver>, PlaceLocation>((ref, center) {
  final geo = ref.watch(geoIndexProvider).asData?.value;
  if (geo == null) return Stream.value(const <NearbyDriver>[]);

  final cells = geo.diskCells(center.latitude, center.longitude, ringSize: 1);
  if (cells.isEmpty) return Stream.value(const <NearbyDriver>[]);

  return FirebaseFirestore.instance
      .collection('driver_locations')
      .where('h3r8', whereIn: cells)
      .snapshots()
      .map((snap) => snap.docs
          .map(_toDriver)
          .whereType<NearbyDriver>()
          .toList());
});

const _staleAfter = Duration(seconds: 60);

NearbyDriver? _toDriver(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  if (data['available'] != true) return null;
  final lat = (data['lat'] as num?)?.toDouble();
  final lng = (data['lng'] as num?)?.toDouble();
  if (lat == null || lng == null) return null;

  final updatedAt = (data['updatedAt'] as Timestamp?)?.toDate();
  if (updatedAt != null && DateTime.now().difference(updatedAt) > _staleAfter) return null;

  return NearbyDriver(
    id: doc.id,
    lat: lat,
    lng: lng,
    heading: (data['driverHeading'] as num?)?.toDouble(),
  );
}
