import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ClsAboutScreen extends StatelessWidget {
  const ClsAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('about'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 150),

            Image.asset(
              "assets/images/debts_manager_image.png",
              width: 100,
              height: 100,
            ),
            SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "app_name".tr(),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'about_description'.tr(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 14),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(Icons.email, color: Colors.grey),
                    // SizedBox(width: 8),
                    // Text('@email.com'),
                    FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
                    SizedBox(width: 8),
                    // Column(
                    //   children: [
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse('https://www.instagram.com/m.5_h109/'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        '@m.5_h109',
                        style: TextStyle(
                          color: Colors.purple,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse('mailto:mohammedreda61dev@gmail.com'),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.email, color: Colors.purple),
                      SizedBox(width: 6),
                      Text(
                        'mohammedreda61dev@gmail.com',
                        style: TextStyle(
                          color: Colors.purple,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),

                // ],
                // ),
              ],
            ),
            // SizedBox(height: 64),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 32),
            //   child: Text(
            //     "support_description_clicking_button".tr(),
            //     textAlign: TextAlign.center,
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),
            // SizedBox(height: 10),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 50),
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor: WidgetStateProperty.all(Colors.green),
            //     ),
            //     onPressed: () {
            //       Navigator.pushNamed(context, 'supportScreen');
            //     },

            //     child: Text(
            //       'support_me'.tr(),
            //       style: Theme.of(context).textTheme.titleMedium,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
