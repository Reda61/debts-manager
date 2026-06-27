import 'package:flutter/material.dart';

class C_ButtonAllDebts extends StatelessWidget {
  final String ButtonLabel;
  final void Function() onPressed;
  const C_ButtonAllDebts({
    super.key,
    required this.ButtonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color.fromARGB(255, 58, 133, 60),
        foregroundColor: Colors.white,
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$ButtonLabel'),
          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
