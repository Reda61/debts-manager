import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/functions/database_functions.dart';
import 'package:expenses4/core/functions/network_functions.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/data/local/local_data_access/debts_data.dart';
import 'package:expenses4/data/local/local_data_access/payments_data.dart';
import 'package:expenses4/data/local/local_data_access/people_data.dart';
import 'package:expenses4/data/local/local_data_access/transactions_data.dart';
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
    // test
    print("get All People-----------------------------------------");
    print(await clsPeople_data.getAllPeople());
    print("get All Debts-----------------------------------------");
    print(await clsDebts_data.getAllDebts());
    print("get All Payments-----------------------------------------");
    print(await clsPayments_data.getAllPayments());
    print("get All Transactions-----------------------------------------");
    print(await clsTransactions_data.getAllTransactions());
  }
}
