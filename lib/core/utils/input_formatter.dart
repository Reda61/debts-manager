import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String text = newValue.text.replaceAll(',', '').replaceAll('٬', '');

    final number = int.tryParse(text);
    if (number == null) return oldValue;

    final formatted = NumberFormat('#,##0').format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
