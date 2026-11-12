import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:taxiway/core/api/api_client.dart';
import 'package:taxiway/core/api/api_connectivity.dart';
import 'package:taxiway/core/api/native_secrets.dart';
import 'package:taxiway/core/api/network_failure.dart';

void main() {
  late int calls;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    FlutterSecureStorage.setMockInitialValues({});
    await NativeSecrets.load();
  });

  setUp(() {
    calls = 0;
    ApiConnectivity.status.value = NetworkStatus.online;
    ApiClient.instance.retryDelays = const [Duration.zero, Duration.zero];
    ApiClient.instance.requestTimeout = const Duration(milliseconds: 150);
  });

  ApiClient clientReturning(Future<http.Response> Function(int call) handler) {
    ApiClient.instance.client = MockClient((request) {
      calls++;
      return handler(calls);
    });
    return ApiClient.instance;
  }

  test('GET retries a 503 and then succeeds', () async {
    final api = clientReturning((call) async => call < 3 ? http.Response('{}', 503) : http.Response('{"data": 1}', 200));

    final result = await api.get('/ping');

    expect(result['data'], 1);
    expect(calls, 3);
    expect(ApiConnectivity.status.value, NetworkStatus.online);
  });

  test('GET gives up after the retry budget and reports server trouble', () async {
    final api = clientReturning((_) async => http.Response('{"message": "down"}', 503));

    await expectLater(api.get('/ping'), throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 503)));

    expect(calls, 3);
    expect(ApiConnectivity.status.value, NetworkStatus.serverError);
  });

  test('a 4xx answer is not retried', () async {
    final api = clientReturning((_) async => http.Response('{"message": "Not found"}', 404));

    await expectLater(
      api.get('/ping'),
      throwsA(isA<ApiException>().having((e) => e.message, 'message', 'Not found')),
    );

    expect(calls, 1);
    expect(ApiConnectivity.status.value, NetworkStatus.online);
  });

  test('POST is never retried, even on a 503', () async {
    final api = clientReturning((_) async => http.Response('{}', 503));

    await expectLater(api.post('/bookings', body: {'a': 1}), throwsA(isA<ApiException>()));

    expect(calls, 1);
  });

  test('a transport failure becomes an offline NetworkFailure and GET retries it', () async {
    final api = clientReturning((_) async => throw http.ClientException('no route to host'));

    await expectLater(
      api.get('/ping'),
      throwsA(isA<NetworkFailure>().having((e) => e.kind, 'kind', NetworkFailureKind.offline)),
    );

    expect(calls, 3);
    expect(ApiConnectivity.status.value, NetworkStatus.offline);
  });

  test('a POST transport failure is not retried', () async {
    final api = clientReturning((_) async => throw http.ClientException('no route to host'));

    await expectLater(api.post('/bookings', body: {}), throwsA(isA<NetworkFailure>()));

    expect(calls, 1);
  });

  test('a hung request times out and flags a slow connection', () async {
    final api = clientReturning((_) => Completer<http.Response>().future);

    await expectLater(
      api.post('/bookings', body: {}),
      throwsA(isA<NetworkFailure>().having((e) => e.kind, 'kind', NetworkFailureKind.timeout)),
    );

    expect(ApiConnectivity.status.value, NetworkStatus.slowConnection);
  });

  test('an HTML error page does not crash decoding', () async {
    final api = clientReturning((_) async => http.Response('<html>Bad gateway</html>', 502));

    await expectLater(
      api.post('/bookings', body: {}),
      throwsA(isA<ApiException>().having((e) => e.message, 'message', 'Something went wrong.')),
    );
  });

  test('a successful call clears an earlier offline status', () async {
    ApiConnectivity.status.value = NetworkStatus.offline;
    final api = clientReturning((_) async => http.Response('{"ok": true}', 200));

    await api.get('/ping');

    expect(ApiConnectivity.status.value, NetworkStatus.online);
  });
}
