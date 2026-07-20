import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart' as settings;
import 'package:expenses4/core/constants/app_constants.dart';
import 'package:expenses4/core/functions/database_functions.dart';
import 'package:expenses4/core/functions/network_functions.dart';
import 'package:expenses4/core/functions/sync_functions.dart';
import 'package:expenses4/core/widgets/dialogs/dialog.dart';
import 'package:expenses4/data/remote/api_service/user_api_service.dart';
import 'package:expenses4/data/remote/auth_service.dart';
import 'package:expenses4/core/shared_references/auth.dart';
import 'package:expenses4/ui/widgets/settings_widgets/c_section_language_change.dart';
import 'package:expenses4/ui/widgets/settings_widgets/theme_switch.dart';
import 'package:flutter/material.dart';

class clsSettingsScreen extends StatefulWidget {
  const clsSettingsScreen({super.key});

  @override
  State<clsSettingsScreen> createState() => _clsSettingsScreenState();
}

class _clsSettingsScreenState extends State<clsSettingsScreen> {
  String _selected = 'ar';

  bool _isLoading = false;

  final List<Map<String, String>> _languages = [
    {'code': 'ar', 'label': 'العربية'},
    {'code': 'en', 'label': 'English'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      setState(() => _selected = context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(),
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            C_themeSwitchSection(),
            Divider(color: Colors.grey, thickness: 1, height: 20),
            C_LanguageChangeSection(
              languagesBoxes: _languages.map((lang) {
                final isSelected = _selected == lang['code'];
                return ChoiceChip(
                  label: Text(lang['label']!),
                  selected: isSelected,
                  onSelected: (_) {
                    context.setLocale(Locale(lang['code']!));
                    setState(() => _selected = lang['code']!);
                  },
                  selectedColor: Color(0xFFEEEDFE),

                  labelStyle: TextStyle(
                    color: isSelected ? Color(0xFF534AB7) : null,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? Color(0xFF534AB7)
                        : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),

            Divider(color: Colors.grey, thickness: 1, height: 20),
          ],
        ),
      ),
    );
  }
}
