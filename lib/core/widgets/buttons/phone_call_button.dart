import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClsPhoneCallButton extends StatelessWidget {
  final String? phoneNumber;
  const ClsPhoneCallButton({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (phoneNumber == null) return;
        final Uri url = Uri(scheme: 'tel', path: '$phoneNumber');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      icon: Icon(Icons.phone),
    );
  }
}
