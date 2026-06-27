import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/data/models/Payment.dart';

class ClsTransaction {
  String? id;
  late double amount;
  late String debtID;
  late String paymentID;
  late String date;
  int isSynced = 0;
  int isDeleted = 0;
  late String updateAt;

  clsDebt? debt;
  clsPayment? payment;

  enMode mode = enMode.AddNew;

  ClsTransaction.empty() {
    id = null;
    amount = 0;
    debtID = "-1";
    paymentID = "-1";
    updateAt = '';

    date = '';
    debt = null;
    payment = null;

    mode = enMode.AddNew;
  }

  ClsTransaction({
    required this.id,
    required this.amount,
    required this.debtID,
    required this.paymentID,
    required this.date,
    required this.debt,
    required this.payment,
    required this.updateAt,
  }) {
    mode = enMode.Updated;
  }
}
