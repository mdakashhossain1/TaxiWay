import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Modern, elevated circular chevron icon back button for Taxiway.
class AppBackButton extends StatelessWidget {
  final Color? iconColor;
  final VoidCallback? onPressed;

  const AppBackButton({
    super.key,
    this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed ??
            () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 2), // Optical centering for chevron
              child: Icon(
                BootstrapIcons.chevron_left,
                color: iconColor ?? AppColors.of(context).navy,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
