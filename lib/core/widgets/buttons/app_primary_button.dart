import 'package:flutter/material.dart';

class ClsBtnPrimary extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const ClsBtnPrimary({super.key, this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color.fromARGB(255, 58, 133, 60),
        foregroundColor: Colors.white,
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      onPressed: onPressed,
      child: Text('${text}'),
    );
  }
}
