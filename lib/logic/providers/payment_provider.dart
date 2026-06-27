import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/payments_data.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/data/models/Payment.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//   CREATE TABLE `payments` (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     amount REAL NOT NULL,
//     date TEXT NOT NULL,
//     debtID INTEGER NOT NULL,
class clsPaymentProvider extends ChangeNotifier {
  clsPayment _payment = clsPayment.empty();

  clsPayment get payment => _payment;

  List<Map> _paymentsOfDebt = [];
  List<Map> _allPayments = [];

  List<Map> get allPayments {
    return _allPayments;
  }

  List<Map> get paymentsOfDebt {
    return _paymentsOfDebt;
  }

  List<Map> _last5Transactions = [];

  List<Map> get last5Transactions {
    return _last5Transactions;
  }

  clsPayment setEmptyPayment() {
    _payment = clsPayment.empty();
    return _payment;
  }

  Future<void> setAllPayments() async {
    List<Map> allPaymentsData = await clsPayments_data.getAllPayments();
    _allPayments = List.from(allPaymentsData);
  }

  Future<void> getPaymentsOfDebt(String debtID) async {
    List<Map> allPaymentsData = await clsPayments_data.getPaymentsByDebtID(
      debtID,
    );
    _paymentsOfDebt = List.from(allPaymentsData);
  }

  static Future<clsPayment?> _getPaymentFromMap(Map map) async {
    clsDebt? debt = await clsDebtProvider().FindByID(map['debtID']);
    if (debt == null) return null;

    clsPayment payment = clsPayment(
      id: map['id'],
      amount: map['amount'],
      debtID: map['debtID'],
      date: map['date'],
      updatedAt: map['updateAt'],
      debt: debt,
    );

    return payment;
  }

  static clsPayment getStandardPaymentFromMap(Map map) {
    clsPayment payment = clsPayment(
      id: map['id'],
      amount: map['amount'],
      debtID: map['debtID'],
      date: map['date'],
      updatedAt: map['updateAt'],
      debt: clsDebt.empty(),
    );

    return payment;
  }
  //   static Future<List<clsPayment>> _convertToTransactionsList(
  //     List<Map<dynamic, dynamic>> data,
  //   ) async {
  //     List<clsPayment> transactionsList = [];
  //     for (var mapItem in data) {
  //       transactionsList.add(await clsPayment._getFromMap(mapItem));
  //     }
  //     return transactionsList;
  //   }

  Future<List<Map>> getPaymentsByDebtID(String debtID) async {
    var data = await clsPayments_data.getPaymentsByDebtID(debtID);
    _paymentsOfDebt = List.from(data);

    return _paymentsOfDebt;
  }

  static Future<clsPayment?> FindByID(String id) async {
    Map<dynamic, dynamic>? data = await clsPayments_data.FindByID(id);

    return data == null ? null : await _getPaymentFromMap(data);
  }

  Future<String> _addNew() async {
    String newID = const Uuid().v4();

    int result = await clsPayments_data.insert(
      paymentID: newID,
      amount: _payment.amount,
      debtID: _payment.debtID,
      date: _payment.date,
    );

    if (result > 0) {
      _payment.id = newID;
      return newID;
    }

    return "-1";
  }

  Future<String> _update() async {
    int result = await clsPayments_data.update(
      _payment.id!,
      _payment.amount,
      _payment.debtID,
      _payment.date,
    );

    if (result > 0) return _payment.id!;

    return "-1";
  }

  Map get paymentMap {
    return {
      'id': _payment.id,
      'amount': _payment.amount,
      'debtID': _payment.debtID,
      'date': _payment.date,
    };
  }

  Map paymentToMapInDetails(clsPayment payment) {
    return {
      'id': payment.id,
      'amount': payment.amount,
      'debtID': payment.debtID,
      'date': payment.date,
      'fullname': payment.debt!.person!.fullname,
      'isPaidToMe': payment.debt!.isPaidToMe,
    };
  }

  void _addNewToPaymentsOfDebt() {
    _paymentsOfDebt.insert(0, paymentMap);
  }

  void _updateToPaymentsOfDebt(String paymentID) {
    final index = _paymentsOfDebt.indexWhere((pa) => pa['id'] == paymentID);

    _paymentsOfDebt[index] = paymentMap;
  }

  void refreshPaymentsProvider() {
    notifyListeners();
  }

  void setPaymentInfo(clsPayment updatedPayment) {
    _payment = updatedPayment;
  }

  Future<void> _addNewToAllPaymentsList() async {
    clsPayment? updatedPayment = await FindByID(_payment.id!);
    if (updatedPayment == null) return;

    // setPaymentInfo(updatedPayment);

    _allPayments.insert(0, paymentToMapInDetails(updatedPayment));
  }

  void _deleteFromPaymentsOfDebt(String paymentID) {
    _paymentsOfDebt.removeWhere((pa) => pa['id'] == paymentID);
  }

  void _deleteFromAllPaymentsList(String paymentID) {
    _allPayments.removeWhere((pa) => pa['id'] == paymentID);
  }

  Future<String> save() async {
    if (_payment.mode == enMode.AddNew) {
      String newID = await _addNew();
      if (newID != "-1") {
        _payment.mode = enMode.Updated;

        _addNewToPaymentsOfDebt();
        await _addNewToAllPaymentsList();
        notifyListeners();

        return newID;
      }
      return newID;
    } else {
      String updateResult = await _update();
      if (updateResult != "-1") {
        _updateToPaymentsOfDebt(_payment.id!);
        notifyListeners();
      }
      return updateResult;
    }
  }

  Future<bool> delete(String paymentID) async {
    bool isDeleted = await clsPayments_data.delete(paymentID) > 0;
    if (isDeleted) {
      _deleteFromPaymentsOfDebt(paymentID);
      _deleteFromAllPaymentsList(paymentID);
      notifyListeners();
    }

    return isDeleted;
  }

  Future<bool> setDelete(String paymentID) async {
    bool isDeleted = await clsPayments_data.markForDelete(paymentID) > 0;
    if (isDeleted) {
      _deleteFromPaymentsOfDebt(paymentID);
      _deleteFromAllPaymentsList(paymentID);
      notifyListeners();
    }

    return isDeleted;
  }
}
