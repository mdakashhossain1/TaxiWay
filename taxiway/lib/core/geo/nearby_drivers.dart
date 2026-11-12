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

const maxNearbyDrivers = 20;
const nearbyDriverStaleAfter = Duration(seconds: 90);

final geoIndexProvider = FutureProvider<GeoIndex>((_) => GeoIndex.instance());

/// The search area for [center] as a stable key, so moving around inside the
/// same cells reuses one Firestore listener instead of opening a new one per
/// GPS fix.
final _searchCellsProvider = Provider.autoDispose.family<String?, PlaceLocation>((ref, center) {
  final geo = ref.watch(geoIndexProvider).asData?.value;
  if (geo == null) return null;
  final cells = geo.diskCells(center.latitude, center.longitude, ringSize: 1)..sort();
  return cells.join(',');
});

final _driversInCellsProvider = StreamProvider.autoDispose.family<List<NearbyDriver>, String>((ref, cellKey) {
  return FirebaseFirestore.instance
      .collection('driver_locations')
      .where('h3r8', whereIn: cellKey.split(','))
      .limit(maxNearbyDrivers)
      .snapshots()
      .map((snap) => snap.docs.map(toNearbyDriver).whereType<NearbyDriver>().toList());
});

/// Live available drivers around [center], found by H3 cell + ring — the same
/// hexagonal index Uber uses for driver search. Queries only by cell (an
/// indexed field); availability and staleness are filtered client-side so no
/// Firestore composite index is required. Empty until H3 loads.
///
/// A document is considered live only if it was updated within
/// [nearbyDriverStaleAfter]; drivers that go offline without a final write
/// simply age out.
final nearbyDriversProvider =
    Provider.autoDispose.family<AsyncValue<List<NearbyDriver>>, PlaceLocation>((ref, center) {
  final cellKey = ref.watch(_searchCellsProvider(center));
  if (cellKey == null) return const AsyncData(<NearbyDriver>[]);
  return ref.watch(_driversInCellsProvider(cellKey));
});

NearbyDriver? toNearbyDriver(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
  return nearbyDriverFrom(doc.id, doc.data(), DateTime.now());
}

NearbyDriver? nearbyDriverFrom(String id, Map<String, dynamic> data, DateTime now) {
  if (data['available'] != true) return null;
  final lat = (data['lat'] as num?)?.toDouble();
  final lng = (data['lng'] as num?)?.toDouble();
  if (lat == null || lng == null) return null;

  final updatedAt = (data['updatedAt'] as Timestamp?)?.toDate();
  if (updatedAt != null && now.difference(updatedAt) > nearbyDriverStaleAfter) return null;

  return NearbyDriver(
    id: id,
    lat: lat,
    lng: lng,
    heading: (data['driverHeading'] as num?)?.toDouble(),
  );
}
