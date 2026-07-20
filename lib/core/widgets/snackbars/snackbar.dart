import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class clsAppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    showTopSnackBar(
      displayDuration: Duration(microseconds: 400),
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
        textStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        icon: Icon(Icons.check, size: 40, color: Colors.greenAccent),
        iconRotationAngle: 0,
        backgroundColor: Colors.green,

        iconPositionLeft: 7,
        iconPositionTop: 14,
        messagePadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
        textStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        icon: Icon(Icons.error, size: 35, color: Colors.white),
        iconPositionLeft: 7,
        iconPositionTop: 14,

        messagePadding: EdgeInsets.symmetric(horizontal: 35),
        iconRotationAngle: 0,
        backgroundColor: Colors.red,
      ),
    );
  }
}
