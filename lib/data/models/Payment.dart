import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/models/Dept.dart';

class clsPayment {
  String? id;
  late double amount;
  late String debtID;
  late String date;
  int isSynced = 0;
  int isDeleted = 0;
  late String updatedAt;

  clsDebt? debt;

  enMode mode = enMode.AddNew;

  clsPayment.empty() {
    id = null;
    amount = 0;
    debtID = "-1";
    date = '';
    debt = null;
    updatedAt = '';

    mode = enMode.AddNew;
  }

  clsPayment({
    required this.id,
    required this.amount,
    required this.debtID,
    required this.date,
    required this.debt,
    required this.updatedAt,
  }) {
    mode = enMode.Updated;
  }
}
