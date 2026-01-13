import 'package:flutter/material.dart';
import 'package:skillhub_app/widget/app_alert_dialog.dart';

Future<void> showAppDialog(
    BuildContext context, {
      required String title,
      required String message,
      bool isError = false,
      VoidCallback? onConfirm,
    }) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AppAlertDialog(
      title: title,
      message: message,
      isError: isError,
      onConfirm: onConfirm,
    ),
  );
}
