import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/payments_data.dart';
import 'package:expenses4/data/local/local_data_access/transactions_data.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/data/models/Payment.dart';
import 'package:expenses4/data/models/transaction.dart';
import 'package:expenses4/logic/providers/debt_provider.dart';
import 'package:expenses4/logic/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

//   CREATE TABLE `transactions` (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     amount REAL NOT NULL,
//     date TEXT NOT NULL,
//     debtID INTEGER NOT NULL,
class ClsTransactionProvider extends ChangeNotifier {
  ClsTransaction _transaction = ClsTransaction.empty();

  void reset() {
    _transaction = ClsTransaction.empty();
    // notifyListeners();
  }

  ClsTransaction get transaction => _transaction;

  List<Map> _allTransactions = [];

  List<Map> get allTransactions {
    return _allTransactions;
  }

  List<Map> _last5Transactions = [];

  List<Map> get last5Transactions {
    return _last5Transactions;
  }

  ClsTransaction setEmptyPayment() {
    _transaction = ClsTransaction.empty();
    return _transaction;
  }

  Future<void> searchOnTransactions(String query) async {
    if (query.trim().isEmpty) {
      await getAllTransactions();
      notifyListeners();
      return;
    }

    List<Map> transactionsDataResult = await clsTransactions_data
        .searchByPersonName(query);

    _allTransactions = List.from(transactionsDataResult);

    notifyListeners();
  }

  Future<void> getAllTransactions() async {
    List<Map> allTransactionsData = await clsTransactions_data
        .getAllTransactions();
    _allTransactions = List.from(allTransactionsData);
  }

  Future<void> setlastTransactions() async {
    List<Map> last5TransactionData = await clsTransactions_data
        .getLast5Transactions();
    _last5Transactions = List.from(last5TransactionData);
    notifyListeners();
  }

  static Future<ClsTransaction?> _getTransactionFromMap(Map map) async {
    clsDebt? debt = await clsDebtProvider().FindByID(map['debtID']);
    if (debt == null) return null;

    clsPayment? payment = await clsPaymentProvider.FindByID(map['paymentID']);
    if (payment == null) return null;

    ClsTransaction transaction = ClsTransaction(
      id: map['id'],
      amount: map['amount'],
      debtID: map['debtID'],
      paymentID: map['paymentID'],
      date: map['date'],
      updateAt: map['updateAt'],
      debt: debt,
      payment: payment,
    );

    return transaction;
  }

  static ClsTransaction getStandardTransactionFromMap(Map map) {
    ClsTransaction transaction = ClsTransaction(
      id: map['id'],
      amount: map['amount'],
      debtID: map['debtID'],
      paymentID: map['paymentID'],
      date: map['date'],
      updateAt: map['updateAt'],
      debt: clsDebt.empty(),
      payment: clsPayment.empty(),
    );

    return transaction;
  }

  static Future<ClsTransaction?> FindByID(String id) async {
    Map<dynamic, dynamic>? data = await clsTransactions_data.FindByID(id);

    return data == null ? null : await _getTransactionFromMap(data);
  }

  Future<String> _addNew() async {
    String newID = const Uuid().v4();

    int result = await clsTransactions_data.insert(
      id: newID,
      amount: _transaction.amount,
      debtID: _transaction.debtID,
      paymentID: _transaction.paymentID,
      date: _transaction.date,
    );

    if (result > 0) {
      _transaction.id = newID;
      return newID;
    }

    return "-1";
  }

  Future<String> _update() async {
    int result = await clsPayments_data.update(
      _transaction.id!,
      _transaction.amount,
      _transaction.debtID,
      _transaction.date,
    );

    if (result > 0) return _transaction.id!;

    return "-1";
  }

  Map get transactionMap {
    return {
      'id': _transaction.id,
      'amount': _transaction.amount,
      'debtID': _transaction.debtID,
      'date': _transaction.date,
    };
  }

  Map transactionToMapInDetails(ClsTransaction transaction) {
    return {
      'id': transaction.id,
      'amount': transaction.amount,
      'debtID': transaction.debtID,
      'date': transaction.date,
      'fullname': transaction.debt!.person!.fullname,
      'isPaidToMe': transaction.debt!.isPaidToMe,
    };
  }

  Future<void> _addNewToTransactionsList() async {
    ClsTransaction? updatedTransaction = await FindByID(_transaction.id!);
    if (updatedTransaction == null) return;

    // setTransactionInfo(updatedTransaction);

    _allTransactions.insert(0, transactionToMapInDetails(updatedTransaction));
  }

  void _deleteFromTransactionsList(String transactionID) {
    _allTransactions.removeWhere((pa) => pa['id'] == transactionID);
    _last5Transactions.removeWhere((pa) => pa['id'] == transactionID);
  }

  void _deleteByPaymentIDFromTransactionsList(String paymentID) {
    _allTransactions.removeWhere((pa) => pa['paymentID'] == paymentID);
    _last5Transactions.removeWhere((pa) => pa['paymentID'] == paymentID);
  }

  Future<String> save() async {
    if (_transaction.mode == enMode.AddNew) {
      String newID = await _addNew();
      if (newID != "-1") {
        _transaction.mode = enMode.Updated;

        await _addNewToTransactionsList();
        notifyListeners();

        return newID;
      }
      return newID;
    } else {
      String updateResult = await _update();
      if (updateResult != "-1") {
        notifyListeners();
      }
      return updateResult;
    }
  }

  Future<bool> delete(String transactionID) async {
    bool isDeleted = await clsTransactions_data.delete(transactionID) > 0;
    if (isDeleted) {
      // _deleteFromTransactionsList(transactionID);
      notifyListeners();
    }

    return isDeleted;
  }

  void refreshTransactionsProvider() {
    notifyListeners();
  }

  Future<bool> setDelete(String transactionID) async {
    bool isDeleted =
        await clsTransactions_data.markForDelete(transactionID) > 0;
    if (isDeleted) {
      _deleteFromTransactionsList(transactionID);
      notifyListeners();
    }

    return isDeleted;
  }

  Future<bool> setDeleteByPaymentID(String paymentID) async {
    bool isDeleted =
        await clsTransactions_data.markForDeleteByPaymentID(paymentID) > 0;
    if (isDeleted) {
      _deleteByPaymentIDFromTransactionsList(paymentID);
      notifyListeners();
    }

    return isDeleted;
  }
}
