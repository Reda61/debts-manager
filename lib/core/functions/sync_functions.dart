import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/functions/database_functions.dart';
import 'package:expenses4/core/functions/network_functions.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/data/remote/sync/sync_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ClsSyncFunctions {
  static Future<void> onSyncRefresh(
    BuildContext context, {
    required bool isReloadCircleRefresh,
  }) async {
    Future<bool> runStep(Future<bool> Function() step) async {
      if (!await ClsNetworkFunctions.hasInternet()) {
        if (isReloadCircleRefresh) {
          if (context.mounted) ClsAppDialog.showInternetStatusDialog(context);
        }
        return false;
      }

      final isComplete = await step();
      if (!isComplete) {
        if (isReloadCircleRefresh) {
          if (context.mounted) {
            ClsAppDialog.showInternetStatusDialog(
              context,
              showMessage: 'no_sync',
            );
          }
        }
        return false;
      }
      return true;
    }

    if (!await runStep(
      () => ClsSyncService.deleteAllData(AppConstants.currentUserID),
    )) {
      return;
    }

    if (!await runStep(
      () => ClsSyncService.uploadAllData(AppConstants.currentUserID),
    )) {
      return;
    }

    if (!await runStep(
      () => ClsSyncService.downloadAllData(AppConstants.currentUserID),
    )) {
      return;
    }

    //Refresh UI

    if (!context.mounted) return;
    ClsDataBaseFuncions.refreshMainScreen(context);

    if (isReloadCircleRefresh) {
      ClsAppDialog.showInternetStatusDialog(
        context,
        showMessage: "sync_done".tr(),
      );
    }
  }

  static Timer? _syncTimer;
  static void startSyncTimer(BuildContext context) {
    void scheduleNext() {
      _syncTimer = Timer(Duration(seconds: 60), () async {
        bool hasInternet = await ClsNetworkFunctions.hasInternet();
        if (hasInternet) {
          await onSyncRefresh(context, isReloadCircleRefresh: false);
        }
        scheduleNext();
      });
    }

    scheduleNext();
  }

  static void stopSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
}
