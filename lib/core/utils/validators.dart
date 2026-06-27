import 'package:easy_localization/easy_localization.dart';

class clsUtils_validator {
  static String? nameValidator(String? val) {
    if (val == null || val.isEmpty) return 'field_empty'.tr();
    if (val.length < 3) return 'name_too_short'.tr();
    if (val.length > 18) return 'name_too_long'.tr();
    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(val))
      return 'name_letters_only'.tr();
    return null;
  }

  static String? iraqPhoneValidator(String val) {
    if (val.length < 3) return null;
    if (!RegExp(r'^07[3-9][0-9]{8}$').hasMatch(val))
      return 'phone_invalid'.tr();
    return null;
  }

  static String? amountValidator(String? val) {
    if (val == null || val.isEmpty) return 'field_empty'.tr();
    if (double.parse(val.replaceAll(',', '')) <= 0)
      return 'amount_greater_than_zero'.tr();
    return null;
  }
}
