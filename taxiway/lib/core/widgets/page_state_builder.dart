import 'package:flutter/material.dart';
import '../theme/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../state/network_state_controller.dart';
import 'app_shimmer.dart';
import 'empty_state.dart';
import 'network_error_view.dart';

/// Manages page-level states:
/// - Loading: a shimmer skeleton, shown only when there is nothing to show yet
/// - Error: a typed offline / timeout / server view with a retry action; it
///   retries itself once the connection comes back
/// - Empty: an [EmptyState]
/// - Data: the real UI. Data already on screen stays visible while a reload is
///   in flight or fails, so a flaky connection never blanks the page.
class PageStateBuilder<T> extends ConsumerWidget {
  final AsyncValue<T> asyncValue;
  final Widget? shimmer;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context, Object error, StackTrace? stackTrace)? errorBuilder;
  final Widget? emptyWidget;
  final bool Function(T data)? isEmpty;
  final Future<void> Function()? onRetry;
  final bool isCompact;

  const PageStateBuilder({
    super.key,
    required this.asyncValue,
    this.shimmer,
    required this.builder,
    this.errorBuilder,
    this.emptyWidget,
    this.isEmpty,
    this.onRetry,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    ref.listen<NetworkState>(networkStateProvider, (previous, next) {
      final reconnected = previous != null && !previous.isOnline && next.isOnline;
      if (reconnected && asyncValue.hasError && !asyncValue.hasValue) onRetry?.call();
    });

    return asyncValue.when(
      skipLoadingOnReload: true,
      skipError: true,
      loading: () => shimmer ?? const GeneralPageShimmer(),
      error: (error, stackTrace) {
        if (errorBuilder != null) {
          return errorBuilder!(context, error, stackTrace);
        }
        return NetworkErrorView(
          type: networkErrorTypeFor(error),
          onRetry: onRetry,
          isCompact: isCompact,
        );
      },
      data: (data) {
        if (isEmpty != null && isEmpty!(data)) {
          return emptyWidget ??
              EmptyState(
                icon: AppIcons.inbox_outlined,
                title: l10n.emptyDefaultTitle,
                message: l10n.emptyDefaultMessage,
              );
        }
        return builder(context, data);
      },
    );
  }
}
