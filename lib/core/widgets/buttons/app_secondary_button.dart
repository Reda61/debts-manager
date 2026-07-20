import 'package:flutter/material.dart';

class ClsBtnSecondary extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const ClsBtnSecondary({super.key, this.onPressed, this.text = 'cancel'});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: Colors.red, width: 2),
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.red.shade100,
        foregroundColor: Colors.red,
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),

      onPressed: onPressed,
      child: Text('${text}'),
    );
  }
}
