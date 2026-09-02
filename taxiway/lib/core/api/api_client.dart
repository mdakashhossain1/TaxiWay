import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'hmac_signer.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final bool expired;
  const ApiException(this.statusCode, this.message, {this.expired = false});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thin signed HTTP client: attaches the HMAC headers every request needs,
/// and the Sanctum bearer token once one has been issued by a verify-otp
/// call. Every repository goes through this instead of calling `http`
/// directly, so token storage and signing logic exist in exactly one place.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const _tokenKey = 'sanctum_token';
  // Matches LocaleController's storage key so the API client doesn't need
  // Riverpod access to know the rider's currently-selected app language.
  static const _localeKey = 'app_locale_code';
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<Map<String, dynamic>> get(String endpoint, {bool auth = true}) => _send('GET', endpoint, auth: auth);

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body, bool auth = true}) =>
      _send('POST', endpoint, body: body, auth: auth);

  Future<Map<String, dynamic>> patch(String endpoint, {Map<String, dynamic>? body, bool auth = true}) =>
      _send('PATCH', endpoint, body: body, auth: auth);

  Future<Map<String, dynamic>> _send(String method, String endpoint, {Map<String, dynamic>? body, bool auth = true}) async {
    final uri = Uri.parse('$kApiBaseUrl$endpoint');
    final rawBody = body == null ? '' : jsonEncode(body);
    // Must exactly match Laravel's $request->path() — no host, no leading
    // slash, and critically no query string (the server signs path() only).
    final signPath = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
    final signed = HmacSigner.sign(method: method, path: signPath, body: rawBody);

    final localeCode = await _storage.read(key: _localeKey);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': localeCode ?? 'en',
      ...signed.toHeaders(),
    };

    if (auth) {
      final token = await readToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    final request = http.Request(method, uri)
      ..headers.addAll(headers)
      ..body = rawBody;

    final http.Response response;
    try {
      final streamed = await request.send();
      response = await http.Response.fromStream(streamed);
    } catch (e) {
      debugPrint('API $method $endpoint -> transport error: $e');
      rethrow;
    }

    final decoded = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('API $method $endpoint -> ${response.statusCode}: ${response.body}');
      throw ApiException(
        response.statusCode,
        decoded['message'] as String? ?? 'Something went wrong.',
        expired: decoded['expired'] == true,
      );
    }

    return decoded;
  }
}
