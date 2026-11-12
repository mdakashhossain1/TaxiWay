import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../api/api_connectivity.dart';

class NetworkState {
  final NetworkStatus status;
  final bool isRetrying;
  final bool justRecovered;
  final DateTime lastChecked;

  const NetworkState({
    this.status = NetworkStatus.online,
    this.isRetrying = false,
    this.justRecovered = false,
    required this.lastChecked,
  });

  bool get isOnline => status == NetworkStatus.online;
  bool get isOffline => status == NetworkStatus.offline;
  bool get isServerError => status == NetworkStatus.serverError;
  bool get isSlow => status == NetworkStatus.slowConnection;

  NetworkState copyWith({
    NetworkStatus? status,
    bool? isRetrying,
    bool? justRecovered,
    DateTime? lastChecked,
  }) {
    return NetworkState(
      status: status ?? this.status,
      isRetrying: isRetrying ?? this.isRetrying,
      justRecovered: justRecovered ?? this.justRecovered,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}

class NetworkStateNotifier extends Notifier<NetworkState> {
  static const _recheckInterval = Duration(seconds: 6);
  static const _slowDecay = Duration(seconds: 6);
  static const _recoveredFlash = Duration(milliseconds: 2500);
  static const _probeUrl = 'https://clients3.google.com/generate_204';

  Timer? _recheck;
  Timer? _slowTimer;
  Timer? _flashTimer;

  @override
  NetworkState build() {
    ApiConnectivity.status.addListener(_onStatusChanged);
    ref.onDispose(() {
      ApiConnectivity.status.removeListener(_onStatusChanged);
      _recheck?.cancel();
      _slowTimer?.cancel();
      _flashTimer?.cancel();
    });
    return NetworkState(status: ApiConnectivity.status.value, lastChecked: DateTime.now());
  }

  void _onStatusChanged() {
    final next = ApiConnectivity.status.value;
    final previous = state.status;
    if (next == previous) return;

    final recovered = next == NetworkStatus.online &&
        (previous == NetworkStatus.offline || previous == NetworkStatus.serverError);
    state = state.copyWith(status: next, justRecovered: recovered, lastChecked: DateTime.now());

    _flashTimer?.cancel();
    if (recovered) {
      _flashTimer = Timer(_recoveredFlash, () => state = state.copyWith(justRecovered: false));
    }

    _slowTimer?.cancel();
    if (next == NetworkStatus.slowConnection) {
      _slowTimer = Timer(_slowDecay, () {
        if (ApiConnectivity.status.value == NetworkStatus.slowConnection) {
          ApiConnectivity.status.value = NetworkStatus.online;
        }
      });
    }

    _recheck?.cancel();
    _recheck = next == NetworkStatus.offline
        ? Timer.periodic(_recheckInterval, (_) => checkConnection())
        : null;
  }

  Future<bool> checkConnection() async {
    if (state.isRetrying) return state.isOnline;
    state = state.copyWith(isRetrying: true);

    var reachable = false;
    try {
      final response = await http.get(Uri.parse(_probeUrl)).timeout(const Duration(seconds: 4));
      reachable = response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      reachable = false;
    }

    state = state.copyWith(isRetrying: false);
    ApiConnectivity.status.value = reachable ? NetworkStatus.online : NetworkStatus.offline;
    return reachable;
  }
}

final networkStateProvider = NotifierProvider<NetworkStateNotifier, NetworkState>(NetworkStateNotifier.new);
