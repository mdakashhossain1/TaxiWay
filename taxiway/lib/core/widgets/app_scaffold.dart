import 'package:flutter/material.dart';
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

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomBar,
    this.padHorizontal = true,
    this.scrollable = false,
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
    return Scaffold(
      appBar: effectiveAppBar,
      body: SafeArea(
        child: scrollable ? SingleChildScrollView(child: content) : content,
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
