import 'package:easy_localization/easy_localization.dart';
// import 'package:intl/intl.dart';

class ClsUtils_Formatter {
  static String amountFormat(num value) {
    return NumberFormat('#,##0').format(value);
  }

  static String formatIsoDate(String rawDate) {
    final dt = DateFormat('M/d/yyyy h:mm:ss a').parse(rawDate);
    return dt.toIso8601String(); // "2026-06-23T20:38:28.000"
  }
}
