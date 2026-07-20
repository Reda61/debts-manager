import 'package:expenses4/core/utils/input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class ClsFormTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final bool readOnly;
  final void Function()? onTap;
  String? Function(String? val)? validatorr;
  final void Function(String?)? onSavedd;
  TextInputType keyboardType;
  String? initval;
  void Function(String)? onChanged;
  bool? isAmount = false;

  ClsFormTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.keyboardType,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.validatorr,
    this.onSavedd,
    this.initval,
    this.onChanged,
    this.isAmount,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: isAmount == true
          ? [
              ThousandsSeparatorFormatter(),
              LengthLimitingTextInputFormatter(10),
            ]
          : [LengthLimitingTextInputFormatter(300)],
      onChanged: onChanged,
      style: isAmount == true ? TextStyle(fontSize: 20) : null,
      onSaved: onSavedd,
      validator: validatorr,
      controller: controller,
      keyboardType: keyboardType,
      initialValue: controller == null ? initval : null,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 194, 193, 193),
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
