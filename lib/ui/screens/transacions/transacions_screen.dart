import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/functions/sync_functions.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/logic/providers/transaction_provider.dart';
import 'package:expenses4/ui/widgets/app_widgets/custom_searchbar.dart';
import 'package:expenses4/ui/widgets/transactions/custom_transactioncard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClsTransacionsScreen extends StatefulWidget {
  ClsTransacionsScreen({super.key});

  @override
  State<ClsTransacionsScreen> createState() => _clsTransactionsScreenState();
}

class _clsTransactionsScreenState extends State<ClsTransacionsScreen> {
  late ClsTransactionProvider transacionPro;
  @override
  void initState() {
    super.initState();
    transacionPro = context.read<ClsTransactionProvider>();
    Future.microtask(() {
      _loadPaymentsList();
      setState(() {});
    });
  }

  // List<Map> _allPaymentsList = [];

  Future<void> _loadPaymentsList() async {
    await transacionPro.getAllTransactions();
    // _allPaymentsList = paymentPro.allPayments;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text('transactions'.tr())),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.end,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              clsCustomSearchBar(
                onChanged: (val) {
                  transacionPro.searchOnTransactions(val);
                },
              ),
              SizedBox(height: 15),

              RefreshIndicator(
                onRefresh: () async {
                  if (AppConstants.currentUserID < 0) {
                    ClsAppDialog.showInternetStatusDialog(
                      context,
                      showMessage: 'sign_in_for_sync',
                    );
                    return;
                  }
                  ClsSyncFunctions.onSyncRefresh(
                    context,
                    isReloadCircleRefresh: true,
                  );
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: 620,
                    child: Consumer<ClsTransactionProvider>(
                      builder: (context, transPro, _) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: transPro.allTransactions.isEmpty
                              ? Center(
                                  child: Text(
                                    "no_transactions".tr(),
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.all(5),
                                  itemCount: transPro.allTransactions.length,
                                  itemBuilder: (context, index) => Dismissible(
                                    key: Key(
                                      transPro.allTransactions[index]['id']
                                          .toString(),
                                    ),
                                    direction: DismissDirection.startToEnd,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(right: 16),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      bool isDeleted = false;
                                      ClsAppDialog.showDeleteConfirm(
                                        context,

                                        onConfirm: () async {
                                          if (await transPro.setDelete(
                                            transPro
                                                .allTransactions[index]['id'],
                                          )) {
                                            isDeleted = true;
                                          }
                                        },
                                      );
                                      return isDeleted;
                                    },
                                    child: clsCustomTransactionCard(
                                      personName: transPro
                                          .allTransactions[index]['fullname'],
                                      amount: transPro
                                          .allTransactions[index]['amount'],
                                      date: transPro
                                          .allTransactions[index]['date'],
                                      // personImagePath: .allTransactionsList[index]['imagepath'],
                                      toMe:
                                          transPro
                                              .allTransactions[index]['isPaidToMe'] ==
                                          1,
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),

              // TextButton(onPressed: () {}, child: Text('Clear All History')),
            ],
          ),
        ),
      ),
    );
  }
}
