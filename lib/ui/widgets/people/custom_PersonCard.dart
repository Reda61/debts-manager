import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/widgets/text_input/c_form_text_field.dart';
import 'package:flutter/material.dart';

class clsPersonCard extends StatelessWidget {
  final String? Function(String?) validatorPersonName;
  final String? Function(String?) validatorPhoneNumberOfPerson;

  final void Function(String?)? onSavedPersonName;
  final void Function(String?)? onSavedPhoneNumberOfPerson;

  final TextEditingController? controllerOfPhoneNumber;
  final TextEditingController? controllerOfPersonName;

  clsPersonCard({
    super.key,
    required this.validatorPersonName,
    required this.validatorPhoneNumberOfPerson,
    this.onSavedPersonName,
    this.onSavedPhoneNumberOfPerson,
    this.controllerOfPhoneNumber,
    this.controllerOfPersonName,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 65,
                  child: CircleAvatar(child: Icon(Icons.person, size: 40)),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClsFormTextField(
                  keyboardType: TextInputType.phone,
                  hintText: 'enter_phone_number'.tr(),
                  labelText: 'phone_number'.tr(),
                  prefixIcon: Icons.phone,
                  controller: controllerOfPhoneNumber,
                  validatorr: validatorPhoneNumberOfPerson,
                  onSavedd: onSavedPhoneNumberOfPerson,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ClsFormTextField(
            hintText: 'enter_person_name'.tr(),
            labelText: 'person_name'.tr(),
            prefixIcon: Icons.person_outline,
            validatorr: validatorPersonName,
            onSavedd: onSavedPersonName,
            controller: controllerOfPersonName,

            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
