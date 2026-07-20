import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/ui/widgets/app_widgets/c_currency_text.dart';
import 'package:expenses4/ui/widgets/debts/c_debt_type_badge.dart';
import 'package:flutter/material.dart';

class ClsCustomTransactionCard extends StatelessWidget {
  final String personName;
  // final String? personImagePath;
  final double amount;
  final bool toMe;
  final String date;

  const ClsCustomTransactionCard({
    super.key,
    required this.personName,
    // this.personImagePath,
    required this.amount,
    required this.toMe,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          // color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Row(
              children: [
                // CircleAvatar(
                //   radius: 30,
                //   backgroundColor: Colors.grey.shade300,
                //   child: Icon(
                //     Icons.person,
                //     color: Colors.grey.shade700,
                //     size: 35,
                //   ),
                // ),
                SizedBox(width: 10),
                Text(
                  '$personName',
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ],
            ),
            SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DebtTypeBadge(
                  debtType: toMe ? enDebtType.Iget : enDebtType.Ipay,
                ),
                SizedBox(width: 10),
                Text(
                  'date'.tr() + ' : ${date}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  ' ${ClsUtils_Formatter.amountFormat(amount)}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: toMe ? Colors.green : Colors.red[900],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  // padding: EdgeInsets.only(top: 5),
                  child: Row(children: [CurrencyText()]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
