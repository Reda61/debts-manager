import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class clsAppDrawer extends StatelessWidget {
  final Function(int) tapOnHome;
  final void Function()? tapOnSettings;

  const clsAppDrawer({
    super.key,
    required this.tapOnHome,
    required this.tapOnSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Text(
              '\n' + 'app_name'.tr(),
              textAlign: TextAlign.center,
              // style: TextStyle(color: Colors.green[400], fontSize: 24),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, size: 30),
            title: Text(
              'home'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              tapOnHome(0); //call back
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on, size: 30),
            title: Text(
              'debts'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'debtsScreen');
            },
          ),
          ListTile(
            leading: Icon(Icons.compare_arrows_sharp, size: 30),
            title: Text(
              'transactions'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () => Navigator.pushNamed(context, 'transactionsScreen'),
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 30),
            title: Text(
              'settings'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: tapOnSettings,
          ),
          ListTile(
            leading: Icon(Icons.info_outline, size: 30),
            title: Text(
              'about'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () => Navigator.pushNamed(context, 'aboutScreen'),
          ),
        ],
      ),
    );
  }
}
