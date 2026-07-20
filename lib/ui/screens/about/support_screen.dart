import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClsSupportScreen extends StatelessWidget {
  const ClsSupportScreen({super.key});

  static const String accountNumber = "7115700648";

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("support_me".tr())),
      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          // const SizedBox(height: 50),
          CircleAvatar(
            radius: 45,
            backgroundColor: color.primary.withOpacity(.1),
            child: Icon(Icons.favorite_rounded, size: 50, color: color.primary),
          ),

          const SizedBox(height: 15),

          Text(
            textAlign: TextAlign.center,
            "support_title".tr(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),
          Text(
            "support_description".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 15),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(
                    "Mastercard_accountNumber".tr(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),

                  const SizedBox(height: 15),

                  SelectableText(
                    accountNumber,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 20),

                  FilledButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        const ClipboardData(text: accountNumber),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("copied".tr())));
                      }
                    },
                    icon: const Icon(Icons.copy),
                    label: Text("copy".tr()),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          Text(
            textAlign: TextAlign.center,
            "thankYou".tr(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(
            "thankYouMessage".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
