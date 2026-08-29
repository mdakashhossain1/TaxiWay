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
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1.5,
      shadowColor: Colors.black12,
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
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 2), // Optical centering for chevron
              child: Icon(
                BootstrapIcons.chevron_left,
                color: iconColor ?? AppColors.navy,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
