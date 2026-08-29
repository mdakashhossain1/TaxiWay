import 'dart:async';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../theme/app_typography.dart';
import '../widgets/app_toast.dart';

enum NetworkStatus {
  online,
  offline,
  serverError,
  slowConnection,
}

class NetworkState {
  final NetworkStatus status;
  final bool isRetrying;
  final String? errorMessage;
  final DateTime lastChecked;

  const NetworkState({
    this.status = NetworkStatus.online,
    this.isRetrying = false,
    this.errorMessage,
    required this.lastChecked,
  });

  bool get isOnline => status == NetworkStatus.online;
  bool get isOffline => status == NetworkStatus.offline;
  bool get isServerError => status == NetworkStatus.serverError;

  NetworkState copyWith({
    NetworkStatus? status,
    bool? isRetrying,
    String? errorMessage,
    DateTime? lastChecked,
  }) {
    return NetworkState(
      status: status ?? this.status,
      isRetrying: isRetrying ?? this.isRetrying,
      errorMessage: errorMessage ?? this.errorMessage,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}

class NetworkStateNotifier extends Notifier<NetworkState> {
  @override
  NetworkState build() => NetworkState(lastChecked: DateTime.now());

  /// Pings Google DNS or backend health check endpoint to determine live status.
  Future<bool> checkConnection({BuildContext? context}) async {
    state = state.copyWith(isRetrying: true);
    try {
      final response = await http
          .get(Uri.parse('https://clients3.google.com/generate_204'))
          .timeout(const Duration(seconds: 4));

      final success = response.statusCode == 204 || response.statusCode == 200;
      final prevStatus = state.status;

      state = state.copyWith(
        status: success ? NetworkStatus.online : NetworkStatus.offline,
        isRetrying: false,
        lastChecked: DateTime.now(),
        errorMessage: success ? null : 'No active internet connection',
      );

      if (context != null && context.mounted) {
        if (prevStatus == NetworkStatus.offline && success) {
          AppToast.success(context, 'Internet connection restored!', title: 'Online');
        } else if (!success) {
          AppToast.error(context, 'No active internet connection found.', title: 'Offline');
        }
      }

      return success;
    } catch (_) {
      state = state.copyWith(
        status: NetworkStatus.offline,
        isRetrying: false,
        lastChecked: DateTime.now(),
        errorMessage: 'Unable to reach the network',
      );
      if (context != null && context.mounted) {
        AppToast.error(context, 'No active internet connection found.', title: 'Offline');
      }
      return false;
    }
  }

  void setOffline(bool offline) {
    state = state.copyWith(
      status: offline ? NetworkStatus.offline : NetworkStatus.online,
      lastChecked: DateTime.now(),
    );
  }

  void setServerError(String message) {
    state = state.copyWith(
      status: NetworkStatus.serverError,
      errorMessage: message,
      lastChecked: DateTime.now(),
    );
  }
}

final networkStateProvider = NotifierProvider<NetworkStateNotifier, NetworkState>(NetworkStateNotifier.new);

/// A subtle, animated top banner displayed when the device is offline.
class OfflineBannerWidget extends ConsumerWidget {
  const OfflineBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkState = ref.watch(networkStateProvider);

    if (networkState.isOnline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: networkState.isServerError ? const Color(0xFFDC2626) : const Color(0xFFE11D48),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              networkState.isServerError ? BootstrapIcons.hdd_network_fill : BootstrapIcons.wifi_off,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              networkState.isServerError ? 'Server Unreachable — Showing cached data' : 'You are offline — Check connection',
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => ref.read(networkStateProvider.notifier).checkConnection(context: context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  networkState.isRetrying ? 'Checking...' : 'Retry',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
