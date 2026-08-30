import 'dart:convert';
import 'dart:io';

const _kUserAgent = 'TaxiwayCabApp/1.0';
const _kTimeout = Duration(seconds: 4);

/// A single OpenStreetMap Nominatim search/reverse result, already cleaned
/// for display via [cleanNominatimDisplayName].
class NominatimResult {
  final double lat;
  final double lon;
  final String displayName;
  const NominatimResult({required this.lat, required this.lon, required this.displayName});
}

/// Forward-geocodes [query] via Nominatim's `/search` endpoint, tagged with
/// [localeCode] (Nominatim's `accept-language` param) so results come back
/// in the app's selected language instead of always English. Returns an
/// empty list on any network/parse failure rather than throwing, so callers
/// can treat this as just one of several search providers to try.
Future<List<NominatimResult>> nominatimForwardGeocode(
  String query,
  String localeCode, {
  String? viewbox,
  String? countryCodes,
  int limit = 8,
}) async {
  final client = HttpClient();
  try {
    client.connectionTimeout = _kTimeout;

    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': query,
      'format': 'json',
      'addressdetails': '1',
      'limit': '$limit',
      'accept-language': localeCode,
      if (countryCodes != null) 'countrycodes': countryCodes,
      if (viewbox != null) 'viewbox': viewbox,
      if (viewbox != null) 'bounded': '0',
    });

    final request = await client.getUrl(uri);
    request.headers.set('User-Agent', _kUserAgent);
    final response = await request.close().timeout(_kTimeout);

    if (response.statusCode != 200) return [];

    final body = await response.transform(utf8.decoder).join();
    final jsonList = jsonDecode(body) as List<dynamic>;

    return jsonList
        .map((item) {
          final lat = double.tryParse(item['lat']?.toString() ?? '') ?? 0.0;
          final lon = double.tryParse(item['lon']?.toString() ?? '') ?? 0.0;
          final displayName = item['display_name'] as String? ?? '';
          return NominatimResult(lat: lat, lon: lon, displayName: cleanNominatimDisplayName(displayName));
        })
        .where((r) => r.lat != 0.0 && r.lon != 0.0 && r.displayName.isNotEmpty)
        .toList();
  } catch (_) {
    return [];
  } finally {
    client.close();
  }
}

/// Reverse-geocodes a coordinate via Nominatim's `/reverse` endpoint, tagged
/// with [localeCode]. Returns null on any failure or empty result.
Future<String?> nominatimReverseGeocode(double lat, double lon, String localeCode) async {
  final client = HttpClient();
  try {
    client.connectionTimeout = _kTimeout;

    final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
      'lat': '$lat',
      'lon': '$lon',
      'format': 'json',
      'accept-language': localeCode,
    });

    final request = await client.getUrl(uri);
    request.headers.set('User-Agent', _kUserAgent);
    final response = await request.close().timeout(_kTimeout);

    if (response.statusCode != 200) return null;

    final body = await response.transform(utf8.decoder).join();
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    final displayName = decoded['display_name'] as String?;

    return (displayName != null && displayName.isNotEmpty) ? cleanNominatimDisplayName(displayName) : null;
  } catch (_) {
    return null;
  } finally {
    client.close();
  }
}

/// Trims a Nominatim `display_name` down to its most useful leading parts,
/// dropping plus-codes and excess trailing administrative noise.
String cleanNominatimDisplayName(String raw) {
  final parts = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  final filtered = parts.where((p) => !p.contains('+')).toList();
  if (filtered.length > 4) {
    return '${filtered.take(4).join(', ')}, Bihar';
  }
  return filtered.join(', ');
}
