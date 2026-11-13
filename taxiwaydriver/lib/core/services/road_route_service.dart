import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoadRoute {
  final List<LatLng> points;
  final double? distanceKm;
  final int? durationMinutes;

  const RoadRoute({required this.points, this.distanceKm, this.durationMinutes});
}

class RoadRouteService {
  RoadRouteService._();
  static final RoadRouteService instance = RoadRouteService._();

  final Map<String, RoadRoute> _cache = {};

  Future<RoadRoute> fetch(LatLng start, LatLng end) async {
    final key = '${start.latitude},${start.longitude}>${end.latitude},${end.longitude}';
    final cached = _cache[key];
    if (cached != null) return cached;

    try {
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List?;
        if (data['code'] == 'Ok' && routes != null && routes.isNotEmpty) {
          final route = routes.first as Map<String, dynamic>;
          final coordinates = (route['geometry'] as Map<String, dynamic>)['coordinates'] as List;
          final points = [
            for (final c in coordinates) LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
          ];
          if (points.length >= 2) {
            final result = RoadRoute(
              points: points,
              distanceKm: ((route['distance'] as num).toDouble() / 1000),
              durationMinutes: ((route['duration'] as num).toDouble() / 60).round(),
            );
            _cache[key] = result;
            return result;
          }
        }
      }
    } catch (_) {}

    return RoadRoute(points: [start, end]);
  }
}
