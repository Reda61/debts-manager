import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/widgets/text_input/c_form_text_field.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ClsCustom_date_picker extends StatelessWidget {
  DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  String? initvalue;
  String? hintText;
  bool readOnly;
  TextEditingController? controller;

  void Function()? onTap;

  ClsCustom_date_picker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.initvalue,
    this.onTap,
    this.hintText,
    this.readOnly = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ClsFormTextField(
      controller: controller,
      initval: initvalue,
      hintText: hintText ?? "",
      labelText: 'date'.tr(),
      prefixIcon: Icons.calendar_today,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: TextInputType.none,
    );
  }
}
