import 'package:expenses4/data/models/person.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';

class clsDebt {
  String? id;
  late String personID;
  late double amount;
  late double paidAmount;
  late bool isPaidToMe;
  late bool isSettled;
  late String date;
  late double remaining;
  int isSynced = 0;
  int isDeleted = 0;
  late String updatedAt;

  String? note;
  clsPerson? person;

  enMode mode = enMode.AddNew;

  clsDebt.empty() {
    id = null;
    personID = "-1";
    amount = 0;
    paidAmount = 0;
    remaining = 0;
    isPaidToMe = false;
    isSettled = false;
    date = '';
    note = null;
    person = null;
    updatedAt = '';
    mode = enMode.AddNew;
  }

  clsDebt({
    required this.id,
    required this.personID,
    required this.amount,
    required this.paidAmount,
    required this.isPaidToMe,
    required this.isSettled,
    required this.date,
    required this.note,
    required this.person,
    required this.updatedAt,
  }) {
    mode = enMode.Updated;
    remaining = amount - paidAmount;
  }
}
