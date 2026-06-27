import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/ui/widgets/app_widgets/c_currency_text.dart';
import 'package:flutter/material.dart';

class C_DebtSummaryCard extends StatelessWidget {
  final enDebtType debtType;
  final double debtValue;

  const C_DebtSummaryCard({
    super.key,
    required this.debtValue,
    required this.debtType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 150,
      decoration: BoxDecoration(
        color: debtType == enDebtType.Ipay
            ? Colors.red[200]
            : Colors.green[200],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              debtType == enDebtType.Ipay
                  ? Icon(
                      Icons.arrow_circle_down_outlined,
                      color: Colors.red[900],
                      size: 40,
                    )
                  : Icon(
                      Icons.arrow_circle_up_outlined,
                      color: Colors.green[900],
                      size: 40,
                    ),
              SizedBox(width: 10),
              Text(
                debtType == enDebtType.Ipay ? 'i_owe'.tr() : 'i_get'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: debtType == enDebtType.Ipay
                      ? Colors.red[900]
                      : Colors.green[900],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          CurrencyText(),

          Text(
            '${ClsUtils_Formatter.amountFormat(debtValue)}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
