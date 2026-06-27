import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/functions/sync_functions.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/logic/providers/transaction_provider.dart';
import 'package:expenses4/ui/widgets/debts/c_debt_summary_card.dart';
import 'package:expenses4/ui/widgets/debts/c_debts_button.dart';
import 'package:expenses4/ui/widgets/transactions/custom_transactioncard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class clsHomeScreen extends StatefulWidget {
  clsHomeScreen({super.key});

  @override
  State<clsHomeScreen> createState() => _clsHomeScreenState();
}

class _clsHomeScreenState extends State<clsHomeScreen> {
  late ClsTransactionProvider _transactionPro;
  @override
  void initState() {
    super.initState();

    _transactionPro = context.read<ClsTransactionProvider>();

    Future.microtask(() async {
      if (mounted) {
        await context.read<clsDebtProvider>().getRecivableSum;
      }
      if (mounted) {
        await context.read<clsDebtProvider>().getPayablesSum;
      } //later-------------------------------------------------

      await _transactionPro.setlastTransactions();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (AppConstants.currentUserID < 0) {
          ClsAppDialog.showInternetStatusDialog(
            context,
            showMessage: 'sign_in_for_sync',
          );
          return;
        }
        await ClsSyncFunctions.onSyncRefresh(
          context,
          isReloadCircleRefresh: true,
        );
      },

      child: Container(
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Selector<clsDebtProvider, double>(
                      selector: (context, proDebt) => proDebt.payablesSum,
                      builder: (context, paySum, _) {
                        return C_DebtSummaryCard(
                          debtValue: paySum,
                          debtType: enDebtType.Ipay,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Selector<clsDebtProvider, double>(
                      selector: (context, proDebt) => proDebt.recievablesSum,
                      builder: (context, reciSum, _) {
                        return C_DebtSummaryCard(
                          debtValue: reciSum,
                          debtType: enDebtType.Iget,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            C_ButtonAllDebts(
              onPressed: () {
                Navigator.pushNamed(context, 'debtsScreen');
              },
              ButtonLabel: 'debts'.tr(),
            ),
            SizedBox(height: 5),

            Container(
              margin: EdgeInsets.only(right: 222),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "transactionsScreen");
                },
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all(Colors.grey),
                ),
                child: Text('recent_activity'.tr() + ' >'),
              ),
            ),
            Selector<ClsTransactionProvider, List<Map>>(
              selector: (context, TransProvider) =>
                  TransProvider.last5Transactions,
              builder: (context, lastTransactions, _) {
                return Container(
                  height: 330,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.all(3),
                  child: lastTransactions.isEmpty
                      ? Center(
                          child: Text(
                            "no_transactions".tr(),
                            style: TextStyle(color: Colors.amber),
                          ),
                        )
                      : ListView.builder(
                          itemCount: lastTransactions.length,
                          itemBuilder: (context, index) {
                            return clsCustomTransactionCard(
                              personName: lastTransactions[index]['fullname'],
                              amount: lastTransactions[index]['amount'],
                              toMe: lastTransactions[index]['isPaidToMe'] == 1,
                              date: lastTransactions[index]['date'],
                            );
                          },
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
