import '../theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../api/api_connectivity.dart';
import '../state/network_state_controller.dart';
import '../theme/app_typography.dart';

class ConnectivityBannerHost extends ConsumerWidget {
  final Widget child;

  const ConnectivityBannerHost({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(networkStateProvider);
    final visible = !network.isOnline || network.justRecovered;

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: double.infinity,
            child: visible ? _ConnectivityBanner(network: network) : null,
          ),
        ),
        Expanded(child: MediaQuery.removePadding(context: context, removeTop: visible, child: child)),
      ],
    );
  }
}

class _BannerStyle {
  final Color background;
  final IconData icon;
  final String message;
  final bool retryable;

  const _BannerStyle(this.background, this.icon, this.message, this.retryable);
}

class _ConnectivityBanner extends ConsumerWidget {
  final NetworkState network;

  const _ConnectivityBanner({required this.network});

  _BannerStyle _styleFor(AppLocalizations l10n) {
    if (network.justRecovered) {
      return _BannerStyle(const Color(0xFF15803D), AppIcons.check_circle_fill, l10n.connectionRestoredTitle, false);
    }
    switch (network.status) {
      case NetworkStatus.offline:
        return _BannerStyle(const Color(0xFF1F2024), AppIcons.wifi_off, l10n.connectionOfflineTitle, true);
      case NetworkStatus.serverError:
        return _BannerStyle(const Color(0xFF1F2024), AppIcons.hdd_network_fill, l10n.connectionServerTroubleTitle, true);
      case NetworkStatus.slowConnection:
        return _BannerStyle(const Color(0xFFB45309), AppIcons.hourglass_split, l10n.connectionSlowTitle, false);
      case NetworkStatus.online:
        return _BannerStyle(const Color(0xFF15803D), AppIcons.check_circle_fill, l10n.connectionRestoredTitle, false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final style = _styleFor(l10n);
    final textStyle = AppTypography.of(context).caption.copyWith(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );

    return Semantics(
      liveRegion: true,
      container: true,
      child: Material(
        color: style.background,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(style.icon, size: 16, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text(style.message, style: textStyle)),
                if (style.retryable) ...[
                  const SizedBox(width: 8),
                  _RetryPill(
                    label: network.isRetrying ? l10n.connectionCheckingAction : l10n.connectionRetryAction,
                    onTap: network.isRetrying ? null : () => ref.read(networkStateProvider.notifier).checkConnection(),
                    style: textStyle,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryPill extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final TextStyle style;

  const _RetryPill({required this.label, required this.onTap, required this.style});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 32, maxWidth: 140),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Center(
              widthFactor: 1,
              child: Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
      ),
    );
  }
}
