import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/ui/widgets/app_widgets/c_currency_text.dart';
import 'package:expenses4/ui/widgets/debts/c_debt_type_badge.dart';
import 'package:flutter/material.dart';

class clsCustomTransactionCard extends StatelessWidget {
  final String personName;
  // final String? personImagePath;
  final double amount;
  final bool toMe;
  final String date;

  const clsCustomTransactionCard({
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey.shade700,
                    size: 45,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$personName',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 4),
                    DebtTypeBadge(
                      debtType: toMe ? enDebtType.Iget : enDebtType.Ipay,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          CurrencyText(),
                          Text(
                            ' ${ClsUtils_Formatter.amountFormat(amount)}',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  color: toMe ? Colors.green : Colors.red[900],
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'date'.tr() + ' : ${date}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
