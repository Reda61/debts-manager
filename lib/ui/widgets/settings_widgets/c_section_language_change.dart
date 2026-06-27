import 'package:flutter/material.dart';

class C_LanguageChangeSection extends StatelessWidget {
  final List<Widget> languagesBoxes;

  const C_LanguageChangeSection({super.key, required this.languagesBoxes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFE6F1FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.language, color: Color(0xFF185FA5)),
          ),
          title: Text('لغة التطبيق'),
          subtitle: Text('App language'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 12),
          child: Wrap(spacing: 8, runSpacing: 8, children: languagesBoxes),
        ),
      ],
    );
  }
}
