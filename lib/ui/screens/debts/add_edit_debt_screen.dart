import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/core/utils/validators.dart';
import 'package:expenses4/core/widgets/buttons/app_primary_button.dart';
import 'package:expenses4/core/widgets/text_input/c_date_picker.dart';
import 'package:expenses4/core/widgets/text_input/c_form_text_field.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/data/models/person.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/logic/providers/person_provider.dart';
import 'package:expenses4/core/widgets/snackbars/snackbar.dart';
import 'package:expenses4/ui/widgets/debts/c_2Choices.dart';
import 'package:expenses4/ui/widgets/people/custom_PersonCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class clsAdd_EditDebt extends StatefulWidget {
  final enMode modeScreen;
  String? debtID;

  clsAdd_EditDebt({super.key, required this.modeScreen, this.debtID});

  @override
  State<clsAdd_EditDebt> createState() => _clsAddEditDebtState();
}

class _clsAddEditDebtState extends State<clsAdd_EditDebt> {
  late TextEditingController dateValueController;

  late TextEditingController fullNamePersonController;
  late TextEditingController phoneNumberController;
  late TextEditingController amountController;
  late TextEditingController noteController;

  // late clsDebt debt;
  // late clsPerson person;

  double remainingDebtBefore = 0;

  late clsDebtProvider debtPro;
  late clsPersonProvider personPro;

  @override
  void initState() {
    super.initState();

    debtPro = context.read<clsDebtProvider>();
    personPro = context.read<clsPersonProvider>();

    debtPro.setEmptyDebt();
    personPro.setEmptyPerson();

    fullNamePersonController = TextEditingController();
    phoneNumberController = TextEditingController();
    amountController = TextEditingController();
    noteController = TextEditingController();
    dateValueController = TextEditingController();

    dateValueController.text = DateTime.now().toIso8601String().substring(
      0,
      10,
    );

    //set debt and person objects and values
    if (widget.modeScreen == enMode.Updated) {
      Future.microtask(() async {
        if (mounted) {
          //debt
          clsDebt? debtData = await debtPro.FindByID(widget.debtID!);
          if (debtData == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                dismissDirection: DismissDirection.horizontal,
                content: Text('data_not_found'.tr()),
                backgroundColor: Colors.red,
              ),
            );
            if (!mounted) return;
            Navigator.pop(context);
            return;
          }

          debtPro.setDebtInfo(debtData);

          // debt = debtData;

          remainingDebtBefore = debtPro.debt.remaining;

          if (debtPro.debt.isSettled) {
            if (!mounted) return;
            Navigator.pop(context);
            clsAppSnackBar.showError(context, "unable_edit".tr());
            return;
          }

          //person
          clsPerson? personData = await personPro.FindByID(
            debtPro.debt.personID,
          );

          if (personData == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                dismissDirection: DismissDirection.horizontal,
                content: Text('data_not_found'.tr()),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pop(context);
            return;
          }
          personPro.setPersonInfo(personData);

          fullNamePersonController.text = debtPro.debt.person!.fullname;
          phoneNumberController.text = debtPro.debt.person!.phone ?? '07';
          dateValueController.text = debtPro.debt.date;
          amountController.text = ClsUtils_Formatter.amountFormat(
            debtPro.debt.amount,
          );
          noteController.text = debtPro.debt.note ?? '';

          setState(() {});
        }
      });
    }

    // false: You Owe, true: You Are Owed
  }

  @override
  void dispose() {
    dateValueController.dispose();
    fullNamePersonController.dispose();
    phoneNumberController.dispose();
    amountController.dispose();
    noteController.dispose();

    super.dispose();
  }

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //If we open this screen from another place
      appBar: AppBar(
        title: Text(
          widget.modeScreen == enMode.AddNew
              ? "add_new_debt".tr()
              : "update_debt".tr(),
          style: TextStyle(color: Colors.green[500]),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.only(top: 0, bottom: 10, right: 20, left: 20),
            children: [
              clsPersonCard(
                controllerOfPersonName: fullNamePersonController,
                controllerOfPhoneNumber: phoneNumberController,
                validatorPersonName: (String? val) {
                  return clsUtils_validator.nameValidator(val);
                },
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'debt_type'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 10),

                  clsCustom2Choices(
                    toMe: debtPro.debt.isPaidToMe,
                    OnTap: (selected) {
                      if (debtPro.debt.mode == enMode.Updated) return;
                      setState(() => debtPro.debt.isPaidToMe = selected);
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),
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
                      controller: amountController,
                      hintText: 'enter_amount'.tr(),
                      labelText: 'amount'.tr(),
                      prefixIcon: Icons.money,
                      keyboardType: TextInputType.number,
                      validatorr: (val) {
                        return clsUtils_validator.amountValidator(val);
                      },
                      isAmount: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              ClsCustom_date_picker(
                controller: dateValueController,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),

                onTap: () async {
                  if (debtPro.debt.paidAmount > 0) return;
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dateValueController.text = picked
                        .toIso8601String()
                        .substring(0, 10);
                  }
                },
              ),
              SizedBox(height: 15),
              ClsFormTextField(
                controller: noteController,
                hintText: 'enter_note'.tr(),
                labelText: 'note_of_debt'.tr(),
                prefixIcon: Icons.text_snippet_outlined,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 15),

              ClsBtnPrimary(
                text: "save".tr(),
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    //Check Debt amount
                    if (widget.modeScreen == enMode.Updated) {
                      if (double.parse(
                            amountController.text.trim().replaceAll(',', ''),
                          ) <=
                          debtPro.debt.paidAmount) {
                        clsAppSnackBar.showError(
                          context,
                          "amount_greater".tr(),
                        );

                        return;
                      }
                      //Check Debt amount
                    }
                    //
                    bool isPersonSave = await setPersonInfoAndSave();
                    bool isDebtSave = await setDebtInfoAndSave();
                    if (!isPersonSave || !isDebtSave) {
                      if (!context.mounted) return;
                      clsAppSnackBar.showError(context, "save_wrong".tr());
                      return;
                    }

                    if (widget.modeScreen == enMode.Updated) {
                      if (!context.mounted) return;
                      context
                          .read<clsDebtProvider>()
                          .reducingDebtsSumsRemaining(remainingDebtBefore);
                      context.read<clsDebtProvider>().addingDebtsSumsRemaining(
                        debtPro.debt.remaining,
                      );
                      Navigator.pop(context);
                    } else {
                      if (!context.mounted) return;
                      context.read<clsDebtProvider>().addingDebtsSumsRemaining(
                        debtPro.debt.amount,
                      );
                      Navigator.pop(context);

                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   'mainScreen',
                      //   (route) => false,
                      //   arguments: 1,
                      // );
                    }
                    if (!context.mounted) return;
                    clsAppSnackBar.showSuccess(context, "save_success".tr());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> setPersonInfoAndSave() async {
    //set Person Info

    personPro.person.fullname = fullNamePersonController.text.trim();
    if (phoneNumberController.text.length > 2)
      personPro.person.phone = phoneNumberController.text.trim();
    else
      personPro.person.phone = null;
    //set Person Info

    //Save Person Info
    // print("${personPro.person.mode} ================================================");
    String resultSave = await context.read<clsPersonProvider>().save();
    // clsPersonProvider().FindByID(resultSave);
    if (resultSave == "-1") {
      return false;
    }
    return true;
    //Save Person Info
  }

  Future<bool> setDebtInfoAndSave() async {
    //set Debt Info
    debtPro.debt.personID = personPro.person.id!;

    debtPro.debt.amount = double.parse(
      amountController.text.replaceAll(',', ''),
    );
    debtPro.debt.remaining = debtPro.debt.amount - debtPro.debt.paidAmount;
    debtPro.debt.date = dateValueController.text;
    debtPro.debt.note = noteController.text.trim().isEmpty
        ? null
        : noteController.text.trim();
    //set Debt Info

    //Save Debt Info
    String savedDebtID = await context.read<clsDebtProvider>().save();
    //Save Debt Info
    if (savedDebtID == "-1") {
      return false;
    }

    return true;
  }
}


  //CREATE TABLE debts (
  //   id INTEGER PRIMARY KEY AUTOINCREMENT,
  //   personID INTEGER NOT NULL,
  //   amount REAL NOT NULL,
  //   paidAmount REAL NOT NULL,
  //   isPaidToMe INTEGER NOT NULL,
  //   isSettled INTEGER NOT NULL,
  //   date TEXT NOT NULL,
  //   note TEXT,
  //   FOREIGN KEY (personID) REFERENCES people(id) ON DELETE CASCADE
  // )