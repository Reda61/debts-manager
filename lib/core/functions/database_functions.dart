import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/functions/network_functions.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/core/widgets/snackbars/snackbar.dart';
import 'package:expenses4/data/local/sql_db.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/logic/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClsDataBaseFuncions {
  static Future<void> clearLocalDataBase() async {
    await SQLDB().clearTable("transactions");
    await SQLDB().clearTable("payments");
    await SQLDB().clearTable("debts");
    await SQLDB().clearTable("people");
  }

  static Future<void> refreshMainScreen(BuildContext context) async {
    ClsTransactionProvider _transactionPro;
    if (!context.mounted) return;
    _transactionPro = context.read<ClsTransactionProvider>();

    clsDebtProvider _debtPro;
    _debtPro = context.read<clsDebtProvider>();

    Future.microtask(() async {
      if (!context.mounted) return;
      await context.read<clsDebtProvider>().getRecivableSum;
      if (!context.mounted) return;
      await context.read<clsDebtProvider>().getPayablesSum;
      if (!context.mounted) return;
      await context.read<clsDebtProvider>().getAllDebts();
      await _transactionPro.setlastTransactions();
      await _transactionPro.getAllTransactions();

      _debtPro.refreshDebtsProvider();
      _transactionPro.refreshTransactionsProvider();
    });
  }
}
