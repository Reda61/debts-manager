// shared/widgets/dialogs/app_dialog.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ClsAppDialog {
  static void showDeleteConfirm(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.delete, color: Colors.red[900], size: 38),
        title: Text('delete'.tr()),
        content: Text('confirm_delete'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            child: Text('delete'.tr()),
          ),
        ],
      ),
    );
  }

  static void showSettleConfirm(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: Text('settle'.tr()),
        content: Text('confirm_settle'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.green[700]),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            child: Text('confirm'.tr()),
          ),
        ],
      ),
    );
  }

  static void showActionConfirm(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.red[900],
          size: 38,
        ),
        title: Text('confirm'.tr()),
        content: Text('are_you_sure'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red[700]),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            child: Text('confirm'.tr()),
          ),
        ],
      ),
    );
  }

  static void showInternetStatusDialog(
    BuildContext context, {
    String showMessage = 'no_net',
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[600],
        content: Text(
          '$showMessage'.tr(),
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    // Future.delayed(Duration(seconds: 2),
    // () {
    //   if (context.mounted) Navigator.of(context).pop();
    // });
  }
}
