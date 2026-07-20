import 'package:expenses4/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CurrencyText extends StatelessWidget {
  const CurrencyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppConstants.currency,
      style: TextStyle(color: Colors.green[900], fontSize: 15),
    );
  }
}
