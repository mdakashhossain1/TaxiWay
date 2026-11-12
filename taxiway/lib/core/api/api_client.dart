import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_connectivity.dart';
import 'hmac_signer.dart';
import 'network_failure.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  final bool expired;
  static const defaultMessage = 'Something went wrong.';
  const ApiException(this.statusCode, this.message, {this.expired = false});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thin signed HTTP client: attaches the HMAC headers every request needs,
/// and the Sanctum bearer token once one has been issued by a verify-otp
/// call. Every repository goes through this instead of calling `http`
/// directly, so token storage and signing logic exist in exactly one place.
///
/// One pooled connection client is reused for every call, each request has a
/// timeout, idempotent GETs retry with backoff, and the outcome of every call
/// is published to [ApiConnectivity] so the UI can show offline / slow /
/// server-trouble banners without each screen re-deriving them.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const _tokenKey = 'sanctum_token';
  // Matches LocaleController's storage key so the API client doesn't need
  // Riverpod access to know the rider's currently-selected app language.
  static const _localeKey = 'app_locale_code';
  static const _slowResponse = Duration(seconds: 4);
  static const _retryDelays = [Duration(milliseconds: 400), Duration(milliseconds: 1200)];
  static const _retryableStatuses = {502, 503, 504};

  final _storage = const FlutterSecureStorage();

  @visibleForTesting
  http.Client client = http.Client();

  @visibleForTesting
  Duration requestTimeout = const Duration(seconds: 15);

  @visibleForTesting
  List<Duration> retryDelays = _retryDelays;

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<Map<String, dynamic>> get(String endpoint, {bool auth = true}) => _send('GET', endpoint, auth: auth);

  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body, bool auth = true}) =>
      _send('POST', endpoint, body: body, auth: auth);

  Future<Map<String, dynamic>> patch(String endpoint, {Map<String, dynamic>? body, bool auth = true}) =>
      _send('PATCH', endpoint, body: body, auth: auth);

  Future<Map<String, dynamic>> _send(String method, String endpoint, {Map<String, dynamic>? body, bool auth = true}) async {
    final canRetry = method == 'GET';
    var attempt = 0;
    while (true) {
      try {
        return await _sendOnce(method, endpoint, body: body, auth: auth);
      } on NetworkFailure {
        if (!canRetry || attempt >= retryDelays.length) rethrow;
      } on ApiException catch (e) {
        if (!canRetry || !_retryableStatuses.contains(e.statusCode) || attempt >= retryDelays.length) rethrow;
      }
      await Future<void>.delayed(retryDelays[attempt]);
      attempt++;
    }
  }

  Future<Map<String, dynamic>> _sendOnce(String method, String endpoint, {Map<String, dynamic>? body, required bool auth}) async {
    final uri = Uri.parse('$kApiBaseUrl$endpoint');
    final rawBody = body == null ? '' : jsonEncode(body);
    // Must exactly match Laravel's $request->path() — no host, no leading
    // slash, and critically no query string (the server signs path() only).
    final signPath = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
    // Signed per attempt: a retry that reused the first nonce would look like
    // a replay to the server.
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

    final elapsed = Stopwatch()..start();
    final http.Response response;
    try {
      final streamed = await client.send(request).timeout(requestTimeout);
      response = await http.Response.fromStream(streamed).timeout(requestTimeout);
    } on TimeoutException {
      debugPrint('API $method $endpoint -> timed out');
      ApiConnectivity.status.value = NetworkStatus.slowConnection;
      throw const NetworkFailure(NetworkFailureKind.timeout);
    } catch (e) {
      debugPrint('API $method $endpoint -> transport error: $e');
      ApiConnectivity.status.value = NetworkStatus.offline;
      throw const NetworkFailure(NetworkFailureKind.offline);
    }

    ApiConnectivity.status.value = response.statusCode >= 500
        ? NetworkStatus.serverError
        : elapsed.elapsed > _slowResponse
            ? NetworkStatus.slowConnection
            : NetworkStatus.online;

    final decoded = _decode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      debugPrint('API $method $endpoint -> ${response.statusCode}: ${response.body}');
      throw ApiException(
        response.statusCode,
        decoded['message'] as String? ?? ApiException.defaultMessage,
        expired: decoded['expired'] == true,
      );
    }

    return decoded;
  }

  Map<String, dynamic> _decode(String body) {
    if (body.isEmpty) return <String, dynamic>{};
    try {
      final value = jsonDecode(body);
      return value is Map<String, dynamic> ? value : <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }
}
