import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/place_location.dart';
import '../utils/geo_utils.dart';
import 'nominatim_client.dart';

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
  static const _localeKey = 'app_locale_code';

  Future<String> _currentLocaleCode() async => (await _storage.read(key: _localeKey)) ?? 'en';

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

    final localeCode = await _currentLocaleCode();

    // 1. First priority: Search within user's local city/state bounding box via Nominatim
    try {
      // Define local bounding box around user's current GPS position (+/- 0.8 deg ~ 90km radius)
      final minLon = origin.longitude - 0.9;
      final maxLon = origin.longitude + 0.9;
      final minLat = origin.latitude - 0.8;
      final maxLat = origin.latitude + 0.8;

      final boundedResults = await nominatimForwardGeocode(
        '$trimmed, Bihar, India',
        localeCode,
        viewbox: '$minLon,$maxLat,$maxLon,$minLat',
        countryCodes: 'in',
        limit: 8,
      );

      for (final r in boundedResults) {
        addResultIfValid(PlaceLocation(latitude: r.lat, longitude: r.lon, address: r.displayName));
      }
    } catch (_) {
      // Continue to next provider
    }

    // 2. Second priority: broader Nominatim search with local state/city bias
    try {
      final searchQuery = lower.contains('bihar') || lower.contains('patna')
          ? trimmed
          : '$trimmed, Patna, Bihar, India';

      final broaderResults = await nominatimForwardGeocode(searchQuery, localeCode, limit: 4);

      for (final r in broaderResults) {
        addResultIfValid(PlaceLocation(latitude: r.lat, longitude: r.lon, address: r.displayName));
      }
    } catch (_) {
      // Provider offline / fallback
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
