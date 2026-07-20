import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class clsCustom2Choices extends StatelessWidget {
  final bool toMe; // false: You Owe, true: You Are Owed
  final void Function(bool) OnTap;
  const clsCustom2Choices({super.key, required this.OnTap, required this.toMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: InkWell(
            onTap: () => OnTap.call(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              height: toMe ? 40 : 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !toMe ? Colors.red.shade100 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade900, width: 2),
              ),
              child: Text(
                'i_owe'.tr(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => OnTap.call(true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              height: toMe ? 48 : 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: toMe ? Colors.green.shade100 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade900, width: 2),
              ),
              child: Text(
                'you_are_owed'.tr(),
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
