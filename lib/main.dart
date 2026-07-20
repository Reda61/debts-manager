import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/routes/app_routes.dart';
import 'package:expenses4/data/remote/auth_service.dart';
import 'package:expenses4/core/themes/app_theme.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/logic/providers/person_provider.dart';
import 'package:expenses4/logic/providers/payment_provider.dart';
import 'package:expenses4/logic/providers/settings_provider.dart';
import 'package:expenses4/logic/providers/transaction_provider.dart';
import 'package:expenses4/test_app.dart';
import 'package:expenses4/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('ar'), Locale('en')],
      path: "assets/translations",
      fallbackLocale: Locale('ar'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => clsDebtProvider()),
          ChangeNotifierProvider(create: (_) => clsPersonProvider()),
          ChangeNotifierProvider(create: (_) => clsPaymentProvider()),
          ChangeNotifierProvider(create: (_) => clsSettingsProvider()),
          ChangeNotifierProvider(create: (_) => ClsTransactionProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: context.watch<clsSettingsProvider>().themeMode,
      darkTheme: ClsAppTheme.darkTheme,
      theme: ClsAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: clsMainScreen(),
      // home: ConnectionTestScreen(),
      routes: AppRoutes.routes,
    );
  }
}
