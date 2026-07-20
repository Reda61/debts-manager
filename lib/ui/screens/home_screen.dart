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
        await context.read<clsDebtProvider>().getRecivableSum();
      }
      if (mounted) {
        await context.read<clsDebtProvider>().getPayablesSum();
      } //later-------------------------------------------------

      await _transactionPro.setlastTransactions();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},

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
            Consumer<ClsTransactionProvider>(
              builder: (context, TransProvider, _) {
                return Container(
                  height: 330,
                  decoration: BoxDecoration(
                    // color: const Color(0xFFF8F9FA),
                    color: Theme.of(context).cardColor,

                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal.shade200, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(7),
                  child: TransProvider.last5Transactions.isEmpty
                      ? Center(
                          child: Text(
                            "no_transactions".tr(),
                            style: TextStyle(color: Colors.amber),
                          ),
                        )
                      : ListView.builder(
                          itemCount: TransProvider.last5Transactions.length,
                          itemBuilder: (context, index) {
                            return ClsCustomTransactionCard(
                              personName: TransProvider
                                  .last5Transactions[index]['fullname'],
                              amount: TransProvider
                                  .last5Transactions[index]['amount'],
                              toMe:
                                  TransProvider
                                      .last5Transactions[index]['isPaidToMe'] ==
                                  1,
                              date: TransProvider
                                  .last5Transactions[index]['date'],
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
