import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart' hide RefreshCallback;
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_back_button.dart';

/// Common scaffold: safe area + standard 20px horizontal screen padding.
/// Automatically injects the custom [AppBackButton] as the AppBar leading
/// widget whenever the current route can be popped (no more Flutter default
/// chevron arrow).
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomBar;
  final bool padHorizontal;
  final bool scrollable;

  /// When set (and [scrollable] is true), wraps the scroll view in a
  /// [LiquidPullToRefresh] instead of a plain [SingleChildScrollView] —
  /// pull down from the top to trigger it.
  final RefreshCallback? onRefresh;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomBar,
    this.padHorizontal = true,
    this.scrollable = false,
    this.onRefresh,
  });

  /// Returns an [AppBar] with the custom circular [AppBackButton] injected as [leading].
  PreferredSizeWidget _injectBackButton(BuildContext context, AppBar bar) {
    if (bar.leading != null) return bar;
    if (!bar.automaticallyImplyLeading) return bar;

    return AppBar(
      key: bar.key,
      leading: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: AppBackButton(),
      ),
      automaticallyImplyLeading: false,
      title: bar.title,
      actions: bar.actions,
      backgroundColor: bar.backgroundColor,
      foregroundColor: bar.foregroundColor,
      elevation: bar.elevation,
      shadowColor: bar.shadowColor,
      surfaceTintColor: bar.surfaceTintColor,
      centerTitle: bar.centerTitle,
      titleSpacing: bar.titleSpacing,
      toolbarHeight: bar.toolbarHeight,
      bottom: bar.bottom,
      shape: bar.shape,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = padHorizontal
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            child: body,
          )
        : body;

    PreferredSizeWidget? effectiveAppBar = appBar;
    if (appBar is AppBar) {
      effectiveAppBar = _injectBackButton(context, appBar as AppBar);
    }

    final bar = bottomBar;
    final scrollView = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: content,
    );

    Widget scrollableBody = scrollView;
    if (scrollable && onRefresh != null) {
      scrollableBody = LiquidPullToRefresh(
        onRefresh: onRefresh!,
        color: AppColors.of(context).primary,
        backgroundColor: AppColors.of(context).card,
        height: 90,
        showChildOpacityTransition: false,
        child: scrollView,
      );
    }

    return Scaffold(
      appBar: effectiveAppBar,
      body: SafeArea(
        child: scrollable ? scrollableBody : content,
      ),
      bottomNavigationBar: bar == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                AppSpacing.md,
              ),
              child: bar,
            ),
    );
  }
}
