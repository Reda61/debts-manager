import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/core/widgets/buttons/app_primary_button.dart';
import 'package:expenses4/core/widgets/buttons/app_secondary_button.dart';
import 'package:expenses4/core/widgets/buttons/phone_call_button.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/core/widgets/snackbars/snackbar.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/logic/providers/payment_provider.dart';
import 'package:expenses4/ui/widgets/payments/c_PaymentCard.dart';
import 'package:expenses4/ui/widgets/debts/c_debt_type_badge.dart';
import 'package:expenses4/ui/widgets/debts/c_note_dialog.dart';
import 'package:expenses4/ui/widgets/debts/c_popup_menu_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class clsDebtInfoScreen extends StatefulWidget {
  clsDebtInfoScreen({super.key, required this.debtID});
  final String debtID;

  @override
  State<clsDebtInfoScreen> createState() => _clsDebtInfoScreenState();
}

class _clsDebtInfoScreenState extends State<clsDebtInfoScreen> {
  late clsDebt _debt;
  List<Map> _paymentsOfDebt = [];

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _debt = clsDebt.empty();

    Future.microtask(() async {
      await loadDebtInfo();
      await loadPayments();

      setState(() {});
    });
  }

  Future<void> loadDebtInfo() async {
    clsDebt? debt = await context.read<clsDebtProvider>().FindByID(
      widget.debtID,
    );

    if (debt == null) {
      if (mounted) {
        clsAppSnackBar.showError(context, "something_wrong".tr());
      }
      return;
    }
    if (!mounted) return;
    context.read<clsDebtProvider>().setDebtInfo(debt);
    _debt = debt;
  }

  Future<void> loadPayments() async {
    _paymentsOfDebt = await context
        .read<clsPaymentProvider>()
        .getPaymentsByDebtID(widget.debtID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("debt_details".tr()),
        actions: [
          ClsPopupMenuButtonOfDebt(
            debtID: _debt.id ?? "-1",
            onEdit: () async {
              await Navigator.pushNamed(
                context,
                'addEditDebt',
                arguments: {
                  'modeScreen': enMode.Updated,
                  'debtID': _debt.id ?? -1,
                },
              );
              await loadDebtInfo();
              setState(() {});
            },

            onDelete: () {
              ClsAppDialog.showDeleteConfirm(
                context,
                onConfirm: () async {
                  bool isDeleted = await context
                      .read<clsDebtProvider>()
                      .setDelete(_debt.id ?? "-1");
                  if (!isDeleted) {
                    if (!context.mounted) return;

                    clsAppSnackBar.showError(context, "something_wrong");
                  }
                  if (!context.mounted) return;

                  Navigator.pop(context);
                },
              );
            },

            onDeptPaid: () {
              ClsAppDialog.showSettleConfirm(
                context,
                onConfirm: () async {
                  bool isSettled = await context.read<clsDebtProvider>().settle(
                    _debt.id ?? "-1",
                  );
                  if (!isSettled) {
                    if (!context.mounted) return;

                    clsAppSnackBar.showError(
                      context,
                      "operation_rejected".tr(),
                    );
                  } else {
                    await loadDebtInfo();
                    await loadPayments();
                    setState(() {});
                  }
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  color: Colors.grey.shade700,
                  size: 40,
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _debt.person == null
                        ? 'no_data'.tr()
                        : '${_debt.person!.fullname}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      // SizedBox(width: 14),
                      SelectableText(
                        _debt.person == null
                            ? 'no_data'.tr()
                            : '${_debt.person!.phone == null ? 'no_phone_number'.tr() : _debt.person!.phone}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                      ),

                      SizedBox(height: 4),
                      Visibility(
                        visible:
                            _debt.person != null && _debt.person!.phone != null,
                        child: ClsPhoneCallButton(
                          phoneNumber: _debt.person == null
                              ? null
                              : _debt.person!.phone == null
                              ? null
                              : _debt.person!.phone,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),
                  DebtTypeBadge(
                    debtType: _debt.isPaidToMe
                        ? enDebtType.Iget
                        : enDebtType.Ipay,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Text(
                '   ${_debt.date}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
              Spacer(),
              Visibility(
                visible: _debt.note != null,
                child: TextButton(
                  onPressed: () {
                    NoteDialog.show(context, _debt.note!);
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.grey),
                  ),
                  child: Text('note_of_debt'.tr() + ' >'),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'paid'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${ClsUtils_Formatter.amountFormat(_debt.paidAmount)}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: _debt.isPaidToMe ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'remaining'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${ClsUtils_Formatter.amountFormat(_debt.amount - _debt.paidAmount)}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        // color: _debt.isPaidToMe ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'total'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${ClsUtils_Formatter.amountFormat(_debt.amount)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 15),
          Text(
            '   ' + 'payments'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade600,
            ),
            height: 270,
            width: double.infinity,
            child: _paymentsOfDebt.isEmpty
                ? Center(
                    child: Text(
                      'no_payments'.tr(),
                      style: TextStyle(color: Colors.amber),
                    ),
                  )
                : ListView.builder(
                    itemCount: _paymentsOfDebt.length,
                    itemBuilder: (context, index) {
                      return clsPaymentCard(
                        isPaidToMe: _debt.isPaidToMe,
                        paymentNumber: _paymentsOfDebt.length - index,
                        paymentDate: _paymentsOfDebt[index]['date'],
                        amount: _paymentsOfDebt[index]['amount'],
                      );
                    },
                    // shrinkWrap: true,
                  ),
          ),
          SizedBox(height: 25),
          Container(
            height: 120,
            padding: EdgeInsets.all(5),
            // color: Colors.amber,
            child: !_debt.isSettled
                ? Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ClsBtnPrimary(
                            text: "add_payment".tr(),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "addPayment",
                                arguments: _debt.id,
                              );
                              // Handle make payment action
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: ClsBtnSecondary(
                            text: "debt_paid".tr(),
                            onPressed: () async {
                              ClsAppDialog.showSettleConfirm(
                                context,
                                onConfirm: () async {
                                  bool isSettled = await context
                                      .read<clsDebtProvider>()
                                      .settle(_debt.id ?? "-1");
                                  if (!isSettled) {
                                    if (!context.mounted) return;

                                    clsAppSnackBar.showError(
                                      context,
                                      "operation_rejected".tr(),
                                    );
                                  }
                                  await loadDebtInfo();
                                  await loadPayments();
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      Divider(thickness: 2),
                      Text(
                        "this_debt_is_paid".tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
