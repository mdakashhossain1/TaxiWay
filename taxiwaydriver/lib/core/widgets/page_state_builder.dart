import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shimmer.dart';
import 'empty_state.dart';
import 'network_error_view.dart';

/// A robust, reusable widget that manages page-level states:
/// - Loading (renders customized Shimmer skeleton)
/// - Network/Server Error (renders 3D NetworkErrorView with Retry action)
/// - Empty state (renders EmptyState)
/// - Data state (renders the actual UI)
class PageStateBuilder<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return asyncValue.when(
      loading: () => shimmer ?? const GeneralPageShimmer(),
      error: (error, stackTrace) {
        if (errorBuilder != null) {
          return errorBuilder!(context, error, stackTrace);
        }
        final errStr = error.toString().toLowerCase();
        NetworkErrorType errorType = NetworkErrorType.generic;
        if (errStr.contains('socket') || errStr.contains('network') || errStr.contains('connection')) {
          errorType = NetworkErrorType.noInternet;
        } else if (errStr.contains('server') || errStr.contains('500') || errStr.contains('502') || errStr.contains('503')) {
          errorType = NetworkErrorType.serverError;
        } else if (errStr.contains('timeout')) {
          errorType = NetworkErrorType.timeout;
        }

        return NetworkErrorView(
          type: errorType,
          onRetry: onRetry,
          isCompact: isCompact,
        );
      },
      data: (data) {
        if (isEmpty != null && isEmpty!(data)) {
          return emptyWidget ?? const EmptyState(
            icon: Icons.inbox_outlined,
            title: 'No Data Found',
            message: 'There are no items available to display right now.',
          );
        }
        return builder(context, data);
      },
    );
  }
}
