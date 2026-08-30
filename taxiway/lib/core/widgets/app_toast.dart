import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, info, warning, error, phone }

/// Thin wrapper around the `toastification` package so call sites keep using
/// the same `AppToast.success/error/info/call` API they always have.
class AppToast {
  static const _phoneType = ToastificationType.custom(
    'phone',
    Color(0xFF2563EB),
    BootstrapIcons.telephone_fill,
  );

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    ToastType type = ToastType.info,
    Duration duration = const Duration(milliseconds: 2800),
  }) {
    toastification.show(
      context: context,
      type: _typeFor(type),
      style: ToastificationStyle.flatColored,
      title: title != null ? Text(title) : null,
      description: Text(message),
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      showProgressBar: false,
      closeOnClick: true,
      dragToClose: true,
    );
  }

  static void success(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.success);
  }

  static void error(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.error);
  }

  static void info(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.info);
  }

  static void call(BuildContext context, String message, {String? title}) {
    show(context, message: message, title: title, type: ToastType.phone);
  }

  static ToastificationType _typeFor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastificationType.success;
      case ToastType.error:
        return ToastificationType.error;
      case ToastType.warning:
        return ToastificationType.warning;
      case ToastType.phone:
        return _phoneType;
      case ToastType.info:
        return ToastificationType.info;
    }
  }
}
