import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:flutter/material.dart';

class DebtTypeBadge extends StatelessWidget {
  final enDebtType debtType;

  const DebtTypeBadge({super.key, required this.debtType});

  @override
  Widget build(BuildContext context) {
    final isIGet = debtType == enDebtType.Iget;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isIGet ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        isIGet ? 'i_get'.tr() : 'i_owe'.tr(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: isIGet ? Colors.green[900] : Colors.red[900],
        ),
      ),
    );
  }
}
