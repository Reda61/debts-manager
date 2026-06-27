import 'package:easy_localization/easy_localization.dart';
import 'package:expenses4/core/utils/formatters.dart';
import 'package:expenses4/ui/widgets/app_widgets/c_currency_text.dart';
import 'package:flutter/material.dart';

class clsPaymentCard extends StatelessWidget {
  final int paymentNumber;
  final String paymentDate;
  final double amount;
  final bool isPaidToMe;
  const clsPaymentCard({
    super.key,
    required this.paymentNumber,
    required this.paymentDate,
    required this.amount,
    required this.isPaidToMe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: CurrencyText(),
        title: Text('payment'.tr() + ' ${paymentNumber}'),
        subtitle: Text('date'.tr() + ': ${paymentDate}'),
        trailing: Text(
          '${ClsUtils_Formatter.amountFormat(amount)}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: isPaidToMe ? Colors.green : Colors.red,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
