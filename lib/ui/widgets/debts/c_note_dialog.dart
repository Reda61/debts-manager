import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NoteDialog {
  static void show(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'note_of_debt'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.deepPurple.shade200),
        ),
        content: SingleChildScrollView(child: Text(note)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}
