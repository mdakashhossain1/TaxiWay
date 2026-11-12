import 'package:h3_flutter/h3_flutter.dart';

/// Thin wrapper over Uber's open-source H3 hexagonal index (Apache-2.0).
///
/// Isolates the one native dependency behind plain strings so the rest of the
/// app never touches `BigInt`/`H3` types — and so the whole thing can be
/// swapped for a geohash implementation if a build target can't link the H3
/// native library. Cells are stored/compared as lowercase hex, which is what
/// the Firestore `driver_locations` documents hold.
class GeoIndex {
  GeoIndex._(this._h3);

  final H3 _h3;
  static GeoIndex? _instance;

  /// H3 resolution 8 ≈ 0.74 km² cells — a sensible radius for city driver
  /// search. Both apps and the backend must agree on this number for cell
  /// strings to match.
  static const driverSearchResolution = 8;

  static Future<GeoIndex> instance() async {
    return _instance ??= GeoIndex._(await const H3Factory().load());
  }

  /// The hex cell containing [lat]/[lng] at [resolution].
  String cell(double lat, double lng, {int resolution = driverSearchResolution}) {
    return _h3.geoToCell(GeoCoord(lat: lat, lon: lng), resolution).toRadixString(16);
  }

  /// The cell at [lat]/[lng] plus the surrounding rings — the search area for
  /// nearby drivers. ringSize 1 = 7 cells, 2 = 19 (within Firestore's whereIn
  /// limit of 30).
  List<String> diskCells(
    double lat,
    double lng, {
    int resolution = driverSearchResolution,
    int ringSize = 1,
  }) {
    final center = _h3.geoToCell(GeoCoord(lat: lat, lon: lng), resolution);
    return _h3.gridDisk(center, ringSize).map((c) => c.toRadixString(16)).toList();
  }
}
