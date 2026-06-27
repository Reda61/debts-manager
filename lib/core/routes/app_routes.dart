import 'package:expenses4/ui/screens/about/about_screen.dart';
import 'package:expenses4/ui/screens/debts/add_edit_debt.dart';
import 'package:expenses4/ui/screens/debts/debt_info.dart';
import 'package:expenses4/ui/screens/debts/debts_screen.dart';
import 'package:expenses4/ui/screens/main_screen.dart';
import 'package:expenses4/ui/screens/payments/add_payment.dart';
import 'package:expenses4/ui/screens/settings/settings_screen.dart';
import 'package:expenses4/ui/screens/transacions/transacions_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    'mainScreen': (context) => clsMainScreen(
      initialIndex: ModalRoute.of(context)?.settings.arguments as int? ?? 0,
    ),
    'debtsScreen': (context) => clsDebtsScreen(),
    'addEditDebt': (context) {
      final Map args = ModalRoute.of(context)!.settings.arguments as Map;
      return clsAdd_EditDebt(
        modeScreen: args['modeScreen'],
        debtID: args['debtID'],
      );
    },
    'addPayment': (context) => clsAddPayment(
      debtID: ModalRoute.of(context)!.settings.arguments as String,
    ),
    'debtInfo': (context) => clsDebtInfoScreen(
      debtID: ModalRoute.of(context)!.settings.arguments as String,
    ),
    'transactionsScreen': (context) => ClsTransacionsScreen(),
    'settingsScreen': (context) => clsSettingsScreen(),
    'aboutScreen': (context) => ClsAboutScreen(),
  };
}
