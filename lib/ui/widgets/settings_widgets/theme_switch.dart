import 'package:expenses4/logic/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class C_themeSwitchSection extends StatelessWidget {
  const C_themeSwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFEEEDFE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.dark_mode, color: Color(0xFF534AB7)),
      ),
      title: Text('الوضع الداكن'),
      subtitle: Text('Dark Mode'),
      value: context.watch<clsSettingsProvider>().themeMode == ThemeMode.dark,
      onChanged: (val) => context.read<clsSettingsProvider>().changeTheme(val),
    );
  }
}
