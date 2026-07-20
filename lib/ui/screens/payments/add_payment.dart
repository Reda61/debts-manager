import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/core/utils/validators.dart';
import 'package:expenses4/core/widgets/buttons/app_primary_button.dart';
import 'package:expenses4/core/widgets/buttons/app_secondary_button.dart';
import 'package:expenses4/core/widgets/snackbars/snackbar.dart';
import 'package:expenses4/core/widgets/text_input/c_date_picker.dart';
import 'package:expenses4/core/widgets/text_input/c_form_text_field.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/data/models/Payment.dart';
import 'package:expenses4/data/models/transaction.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/logic/providers/payment_provider.dart';
import 'package:expenses4/logic/providers/transaction_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class clsAddPayment extends StatefulWidget {
  final String debtID;
  const clsAddPayment({super.key, required this.debtID});

  @override
  State<clsAddPayment> createState() => _clsAddPaymentState();
}

class _clsAddPaymentState extends State<clsAddPayment> {
  late clsDebt _debt;
  late clsDebtProvider _debtPro;
  late clsPayment _newPayment;

  late clsPaymentProvider paymentPro;

  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController noteController;

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  initState() {
    super.initState();

    noteController = TextEditingController();
    dateController = TextEditingController();
    amountController = TextEditingController();

    dateController.text = DateTime.now().toIso8601String().substring(0, 10);

    paymentPro = context.read<clsPaymentProvider>();

    _newPayment = context.read<clsPaymentProvider>().setEmptyPayment();

    _debtPro = context.read<clsDebtProvider>();
    _debt = context.read<clsDebtProvider>().debt;
  }

  dispose() {
    noteController.dispose();
    dateController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('\n' + 'add_payment'.tr())),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _debt.person == null
                          ? 'no_data'.tr()
                          : '${_debt.person!.fullname}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          'remaining'.tr() + ' :',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: Colors.grey.shade600),
                        ),
                        Text(
                          ' ${ClsUtils_Formatter.amountFormat(_debt.amount - _debt.paidAmount)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 40),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    if (amountController.text.length > 7) return;
                    amountController.text += ',000';
                  },
                  child: Text('000', style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: ClsFormTextField(
                    isAmount: true,
                    controller: amountController,
                    hintText: 'enter_amount'.tr(),
                    labelText: 'amount'.tr(),
                    prefixIcon: Icons.money,
                    keyboardType: TextInputType.number,
                    validatorr: (String? val) {
                      if (val!.isEmpty) return "The amount is Empty";
                      double paymentAmount = double.parse(
                        amountController.text.replaceAll(',', ''),
                      );
                      if (paymentAmount > (_debt.amount - _debt.paidAmount)) {
                        return "payment_exceeds_debt".tr();
                      }
                      return clsUtils_validator.amountValidator(val);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),

            ClsCustom_date_picker(
              controller: dateController,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),

              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: _debt.paidAmount == 0
                      ? DateTime.parse(_debt.date)
                      : paymentPro.paymentsOfDebt.firstOrNull == null
                      ? DateTime(2010)
                      : DateTime.parse(paymentPro.paymentsOfDebt[0]['date']),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  dateController.text = picked.toIso8601String().substring(
                    0,
                    10,
                  );
                }
              },
            ),

            SizedBox(height: 220),
            ClsBtnPrimary(
              text: 'add_payment'.tr(),

              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                bool IsDebtUpdated = await _isDebtUpdated();

                if (!IsDebtUpdated) {
                  if (!context.mounted) return;
                  clsAppSnackBar.showError(context, "something_wrong".tr());
                  Navigator.pop(context);
                  return;
                }
                bool isPaymentSaved = await _setPaymentInfoAndSave();
                if (!isPaymentSaved) {
                  if (!context.mounted) return;

                  clsAppSnackBar.showError(context, "something_wrong".tr());
                  Navigator.pop(context);
                  return;
                }
                if (!context.mounted) return;

                clsAppSnackBar.showSuccess(
                  context,
                  'payment_added_success'.tr(),
                );
                context.read<clsDebtProvider>().reducingDebtsSumsRemaining(
                  double.parse(amountController.text.replaceAll(',', '')),
                );

                context.read<ClsTransactionProvider>().setlastTransactions();

                Navigator.pop(context);
              },
            ),

            SizedBox(height: 9),

            ClsBtnSecondary(
              text: 'cancel'.tr(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _setPaymentInfoAndSave() async {
    _newPayment.amount = double.parse(
      amountController.text.trim().replaceAll(',', ''),
    );
    _newPayment.date = dateController.text;
    _newPayment.debtID = _debt.id!;
    String paymentSaveResult = await context.read<clsPaymentProvider>().save();

    if (paymentSaveResult == "-1") return false;

    //Add new Transaction
    if (mounted) {
      context.read<ClsTransactionProvider>().reset();
    }
    if (!mounted) return false;
    ClsTransaction trans = context.read<ClsTransactionProvider>().transaction;

    trans.paymentID = _newPayment.id!;
    trans.debtID = _newPayment.debtID;
    trans.amount = _newPayment.amount;
    trans.date = _newPayment.date;

    String transactionSaveResult = "1";
    if (mounted) {
      transactionSaveResult = await context
          .read<ClsTransactionProvider>()
          .save();
    }
    return transactionSaveResult != "-1";
  }

  Future<bool> _isDebtUpdated() async {
    // if (await context.read<clsDebtProvider>().FindByID(_debt.id!) == null) {
    //   return false;
    // }
    _debt.paidAmount += double.parse(amountController.text.replaceAll(',', ''));
    _debt.remaining = _debt.amount - _debt.paidAmount;
    if (_debt.remaining <= 0) {
      _debt.isSettled = true;
    }

    _debtPro.reducingDebtsSumsRemaining(
      double.parse(amountController.text.replaceAll(',', '')),
    );

    String upatedID = await context.read<clsDebtProvider>().save();

    return upatedID != "-1";
  }
}
