import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import '../models/place_location.dart';
import '../utils/geo_utils.dart';

abstract class PlaceRepository {
  PlaceLocation get currentLocation;
  Future<PlaceLocation> fetchExactCurrentLocation();
  void updateCurrentLocation(PlaceLocation loc);
  Future<List<PlaceLocation>> search(String query, {PlaceLocation? proximityOrigin});
  Future<List<PlaceLocation>> getRecentHistory();
  Future<void> addRecent(PlaceLocation place);
  Future<void> removeRecent(PlaceLocation place);
  Future<void> clearRecentHistory();
}

class MockPlaceRepository implements PlaceRepository {
  static const _storage = FlutterSecureStorage();
  static const _historyKey = 'user_places_search_history';

  final _geocoding = geocoding.Geocoding();

  PlaceLocation _currentLocation = const PlaceLocation(
    latitude: 25.5980,
    longitude: 85.1280,
    address: 'Mithapur, Patna, Bihar',
  );

  @override
  PlaceLocation get currentLocation => _currentLocation;

  @override
  void updateCurrentLocation(PlaceLocation loc) {
    _currentLocation = loc;
  }

  @override
  Future<PlaceLocation> fetchExactCurrentLocation() async {
    final live = await detectExactCurrentLocation();
    if (live != null) {
      _currentLocation = live;
    }
    return _currentLocation;
  }

  @override
  Future<List<PlaceLocation>> search(String query, {PlaceLocation? proximityOrigin}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final lower = trimmed.toLowerCase();
    final origin = proximityOrigin ?? currentLocation;
    final List<PlaceLocation> results = [];
    final Set<String> seenKeys = {};

    void addResultIfValid(PlaceLocation loc) {
      // Discard invalid / 0,0 coordinates
      if (loc.latitude == 0.0 && loc.longitude == 0.0) return;

      final key = '${loc.latitude.toStringAsFixed(3)},${loc.longitude.toStringAsFixed(3)}';
      if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        results.add(loc);
      }
    }

    // 1. First priority: Search within user's local city/state bounding box via Nominatim
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 4);

      // Define local bounding box around user's current GPS position (+/- 0.8 deg ~ 90km radius)
      final minLon = origin.longitude - 0.9;
      final maxLon = origin.longitude + 0.9;
      final minLat = origin.latitude - 0.8;
      final maxLat = origin.latitude + 0.8;

      // Query 1A: Search with local city/state appended & bounded to India
      final localQuery = Uri.encodeComponent('$trimmed, Bihar, India');
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$localQuery&format=json&addressdetails=1&limit=8&countrycodes=in&viewbox=$minLon,$maxLat,$maxLon,$minLat&bounded=0',
      );

      final request = await client.getUrl(url);
      request.headers.set('User-Agent', 'TaxiwayCabApp/1.0');
      final response = await request.close().timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final jsonList = jsonDecode(body) as List<dynamic>;

        for (final item in jsonList) {
          final lat = double.tryParse(item['lat']?.toString() ?? '') ?? 0.0;
          final lon = double.tryParse(item['lon']?.toString() ?? '') ?? 0.0;
          final displayName = item['display_name'] as String? ?? '';

          if (lat != 0.0 && lon != 0.0 && displayName.isNotEmpty) {
            // Clean up long address strings to keep them clean
            final cleanedAddress = _cleanDisplayName(displayName);
            addResultIfValid(PlaceLocation(
              latitude: lat,
              longitude: lon,
              address: cleanedAddress,
            ));
          }
        }
      }
      client.close();
    } catch (_) {
      // Continue to next provider
    }

    // 2. Query platform Google Geocoding with local state/city bias
    try {
      final searchQuery = lower.contains('bihar') || lower.contains('patna')
          ? trimmed
          : '$trimmed, Patna, Bihar, India';

      final locations = await _geocoding.locationFromAddress(searchQuery).timeout(
        const Duration(seconds: 3),
        onTimeout: () => [],
      );

      for (final loc in locations.take(4)) {
        String formattedAddress = '$trimmed, Patna, Bihar';
        try {
          final placemarks = await _geocoding.placemarkFromCoordinates(loc.latitude, loc.longitude);
          if (placemarks.isNotEmpty) {
            final p = placemarks.first;
            final isPlus = p.name != null && p.name!.contains('+');
            final parts = <String>{
              if (p.name != null && p.name!.isNotEmpty && !isPlus) p.name!,
              if (p.street != null && p.street!.isNotEmpty && p.street != p.name && !p.street!.contains('+')) p.street!,
              if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality!,
              if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
              if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty) p.administrativeArea!,
            }.toList();
            if (parts.isNotEmpty) {
              formattedAddress = parts.join(', ');
            }
          }
        } catch (_) {}

        addResultIfValid(PlaceLocation(
          latitude: loc.latitude,
          longitude: loc.longitude,
          address: formattedAddress,
        ));
      }
    } catch (_) {
      // Device geocoder offline / fallback
    }

    // 3. Filter out far-flung international locations (> 500 km away) for local cab service
    final localResults = results.where((loc) {
      final distance = haversineKm(origin, loc);
      return distance <= 500.0; // Within operational cab radius (state/intercity)
    }).toList();

    final finalResults = localResults.isNotEmpty ? localResults : results;

    // If still empty, provide a localized pinpoint fallback
    if (finalResults.isEmpty) {
      finalResults.add(PlaceLocation(
        latitude: origin.latitude,
        longitude: origin.longitude,
        address: '$trimmed, Patna, Bihar',
      ));
    }

    // 4. Sort strictly by nearest distance from current user GPS position first
    finalResults.sort((a, b) {
      final distA = haversineKm(origin, a);
      final distB = haversineKm(origin, b);
      return distA.compareTo(distB);
    });

    return finalResults;
  }

  /// Clean up redundant country/code noise from display names for a clean UI
  String _cleanDisplayName(String raw) {
    final parts = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    // Filter out plus codes or postal codes if needed
    final filtered = parts.where((p) => !p.contains('+')).toList();
    if (filtered.length > 4) {
      return '${filtered.take(4).join(', ')}, Bihar';
    }
    return filtered.join(', ');
  }

  @override
  Future<List<PlaceLocation>> getRecentHistory() async {
    try {
      final raw = await _storage.read(key: _historyKey);
      if (raw == null || raw.isEmpty) {
        return [];
      }
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => PlaceLocation.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addRecent(PlaceLocation place) async {
    try {
      final current = await getRecentHistory();
      // Remove any existing duplicate
      current.removeWhere((p) =>
          p.address == place.address ||
          ((p.latitude - place.latitude).abs() < 0.0005 && (p.longitude - place.longitude).abs() < 0.0005));
      // Prepend to front
      current.insert(0, place);
      // Keep maximum 15 recent searches
      final trimmed = current.take(15).toList();
      final jsonStr = jsonEncode(trimmed.map((e) => e.toJson()).toList());
      await _storage.write(key: _historyKey, value: jsonStr);
    } catch (_) {}
  }

  @override
  Future<void> removeRecent(PlaceLocation place) async {
    try {
      final current = await getRecentHistory();
      current.removeWhere((p) =>
          p.address == place.address ||
          ((p.latitude - place.latitude).abs() < 0.0005 && (p.longitude - place.longitude).abs() < 0.0005));
      final jsonStr = jsonEncode(current.map((e) => e.toJson()).toList());
      await _storage.write(key: _historyKey, value: jsonStr);
    } catch (_) {}
  }

  @override
  Future<void> clearRecentHistory() async {
    try {
      await _storage.delete(key: _historyKey);
    } catch (_) {}
  }
}
