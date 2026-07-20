import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String text = ArabicToEnglishConverter.convert(newValue.text);

    text = text.replaceAll(',', '').replaceAll('٬', '');

    final number = int.tryParse(text);
    if (number == null) return oldValue;

    final formatted = NumberFormat('#,##0').format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ArabicToEnglishConverter {
  static String convert(String text) {
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    const englishDigits = '0123456789';

    for (int i = 0; i < arabicDigits.length; i++) {
      text = text.replaceAll(arabicDigits[i], englishDigits[i]);
    }

    return text;
  }
}
