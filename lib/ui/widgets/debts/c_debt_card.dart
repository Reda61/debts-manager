import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/core/widgets/snackbars/snackbar.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/ui/widgets/app_widgets/c_currency_text.dart';
import 'package:expenses4/ui/widgets/debts/c_debt_type_badge.dart';
import 'package:expenses4/ui/widgets/debts/c_popup_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class clsDebtCard extends StatelessWidget {
  final String personName;
  final String personImageUrl;
  final double amount;
  final double paidAmount;
  final String date;
  final enDebtType
  debtType; // true if the user owes money, false if they are owed money
  final bool isPaid; // true if the debt is fully paid, false otherwise

  final String debtID;

  const clsDebtCard({
    super.key,
    required this.personName,
    required this.amount,
    required this.debtType,
    required this.personImageUrl,
    required this.date,
    required this.paidAmount,
    required this.isPaid,
    required this.debtID,
  });

  double get percentageRemaining => (amount - paidAmount) / amount;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "debtInfo", arguments: debtID);
      },
      child: Padding(
        padding: EdgeInsets.all(isPaid ? 7.0 : 0),
        child: Card(
          child: Stack(
            alignment: AlignmentGeometry.center,
            children: [
              Container(
                decoration: !isPaid
                    ? BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).cardColor,
                      )
                    : BoxDecoration(
                        border: Border.all(
                          color: debtType == enDebtType.Iget
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                padding: EdgeInsets.all(15),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey.shade700,
                                      size: 45,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$personName',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      SizedBox(height: 7),
                                      Row(
                                        children: [
                                          DebtTypeBadge(debtType: debtType),
                                          SizedBox(width: 7),

                                          Text(
                                            '$date',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    ' ${ClsUtils_Formatter.amountFormat(amount)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: debtType == enDebtType.Iget
                                              ? Colors.green
                                              : Colors.red[900],
                                        ),
                                  ),
                                  SizedBox(width: 5),

                                  CurrencyText(),
                                ],
                              ),

                              SizedBox(height: 6),
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          child: ClsPopupMenuButtonOfDebt(
                            debtID: debtID,
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                'addEditDebt',
                                arguments: {
                                  'modeScreen': enMode.Updated,
                                  'debtID': debtID,
                                },
                              );
                            },
                            onDelete: () {
                              ClsAppDialog.showDeleteConfirm(
                                context,
                                onConfirm: () async {
                                  bool isDeleted = await context
                                      .read<clsDebtProvider>()
                                      .setDelete(debtID);
                                  if (!isDeleted) {
                                    clsAppSnackBar.showError(
                                      context,
                                      "something_wrong".tr(),
                                    );
                                  }
                                },
                              );
                            },
                            onDeptPaid: () {
                              ClsAppDialog.showSettleConfirm(
                                context,
                                onConfirm: () async {
                                  bool isSettled = await context
                                      .read<clsDebtProvider>()
                                      .settle(debtID);
                                  if (!isSettled) {
                                    clsAppSnackBar.showError(
                                      context,
                                      "operation_rejected".tr(),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${(percentageRemaining * 100).toStringAsFixed(0)}% ' +
                          'remaining'.tr() +
                          ' || ' +
                          'paid'.tr() +
                          ': ${ClsUtils_Formatter.amountFormat(paidAmount)}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: 1 - percentageRemaining,
                      backgroundColor: Colors.blueGrey.shade100,
                      color: debtType == enDebtType.Iget
                          ? Colors.green[700]
                          : Colors.red[900],
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
              isPaid
                  ? Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        Divider(
                          thickness: 22,
                          color: debtType == enDebtType.Iget
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                        ),
                        Text(
                          "this_debt_is_paid".tr(),
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                // backgroundColor: Colors.amber,
                              ),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
