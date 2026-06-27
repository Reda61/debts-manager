import 'package:expenses4/data/local/local_data_access/debts_data.dart';
import 'package:expenses4/core/my_own_enums/enums.dart';
import 'package:expenses4/data/local/local_data_access/payments_data.dart';
import 'package:expenses4/data/local/local_data_access/transactions_data.dart';
import 'package:expenses4/data/models/Dept.dart';
import 'package:expenses4/data/models/person.dart';
import 'package:expenses4/logic/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class clsDebtProvider extends ChangeNotifier {
  clsDebt _debt = clsDebt.empty();

  clsDebt get debt => _debt;

  double _payablesSum = 0;
  double _recievablesSum = 0;

  double get payablesSum {
    return _payablesSum;
  }

  double get recievablesSum {
    return _recievablesSum;
  }

  List<Map> _Debts = [];
  List<Map> get Debts => _Debts;

  List<Map> _payablesDebts = [];
  List<Map> get payablesDebts => _payablesDebts;

  List<Map> _receivablesDebts = [];
  List<Map> get receivablesDebts => _receivablesDebts;

  Future<double> get getRecivableSum async {
    _recievablesSum = await clsDebts_data.getSumReciveables();
    return recievablesSum;
  }

  Future<double> get getPayablesSum async {
    _payablesSum = await clsDebts_data.getSumPayables();
    return payablesSum;
  }

  List<List<Map>> selectedDebtsTypeList = [];

  List<Map> _searchResultsAllDebts = [];
  List<Map> get searchResultsAllDebts => _searchResultsAllDebts;

  List<Map> _searchResultsPayDebts = [];
  List<Map> get searchResultsPayDebts => _searchResultsPayDebts;

  List<Map> _searchResultsRecievDebts = [];
  List<Map> get searchResultsRecievDebts => _searchResultsRecievDebts;

  Future<void> searchDebts(String query) async {
    if (query.trim().isEmpty) {
      await getAllDebts();
      notifyListeners();
    } else {
      // _searchResultsAllDebts = _Debts.where((deb) {
      //   return deb['fullname'].toString().startsWith(query);
      // }).toList();
      //  _searchResultsPayDebts = _payablesDebts.where((deb) {
      //   return deb['fullname'].toString().startsWith(query);
      // }).toList();
      //  _searchResultsRecievDebts = _receivablesDebts.where((deb) {
      //   return deb['fullname'].toString().startsWith(query);
      // }).toList();
      _Debts = List.of(await clsDebts_data.searchAllDebts(query));
      _payablesDebts = List.of(await clsDebts_data.searchPayDebts(query));
      _receivablesDebts = List.of(await clsDebts_data.searchRecievDebts(query));
    }

    setDebtsTypeLists();
    notifyListeners();
  }

  void setDebtsTypeLists() {
    selectedDebtsTypeList = [_Debts, _receivablesDebts, _payablesDebts];
  }

  void reducingDebtsSumsRemaining(double amount) {
    if (_debt.isPaidToMe) {
      _recievablesSum -= amount;
    } else {
      _payablesSum -= amount;
    }
  }

  void addingDebtsSumsRemaining(double amount) {
    if (_debt.isPaidToMe) {
      _recievablesSum += amount;
    } else {
      _payablesSum += amount;
    }
  }

  Future<void> getAllDebts() async {
    List<Map> data = await clsDebts_data.getAllDebts();
    _Debts = List.from(data);
    await _getAllPayables();
    await _getAllRecievables();
    setDebtsTypeLists();
  }

  void refreshDebtsProvider() {
    notifyListeners();
  }

  Future<void> _getAllPayables() async {
    List<Map> data = await clsDebts_data.getPayables();

    _payablesDebts = List.from(data);
  }

  Future<void> _getAllRecievables() async {
    List<Map> data = await clsDebts_data.getReceivables();
    _receivablesDebts = List.from(data);
  }

  void setDebtInfo(clsDebt updatedDebt) {
    _debt = updatedDebt;
  }

  clsDebt setEmptyDebt() {
    _debt = clsDebt.empty();
    return _debt;
  }

  Map toMap(clsDebt debt) {
    return {
      'id': debt.id,
      'personID': debt.personID,
      'amount': debt.amount,
      'paidAmount': debt.paidAmount,
      'isPaidToMe': debt.isPaidToMe ? 1 : 0,
      'isSettled': debt.isSettled ? 1 : 0,
      'date': debt.date,
      'note': debt.note,
      'fullname': debt.person!.fullname,
      'imagepath': debt.person!.imagepath,
    };
  }

  Future<bool> _addNewToDebts() async {
    clsDebt? updatedDebt = await FindByID(_debt.id!);
    if (updatedDebt == null) return false;

    Map debtMap = toMap(updatedDebt);

    _Debts.insert(0, debtMap);
    if (_debt.isPaidToMe) {
      _receivablesDebts.insert(0, debtMap);
    } else {
      _payablesDebts.insert(0, debtMap);
    }
    return true;
  }

  Future<bool> _updateDebtToDebts() async {
    final int index = _Debts.indexWhere((de) => de['id'] == _debt.id);

    clsDebt? updatedDebt = await FindByID(_debt.id!);
    if (updatedDebt == null) return false;

    Map debtMap = toMap(updatedDebt);

    _Debts[index] = debtMap;

    if (_debt.isPaidToMe) {
      final int recIndex = _receivablesDebts.indexWhere(
        (de) => de['id'] == debt.id,
      );

      if (recIndex != -1) {
        _receivablesDebts[recIndex] = debtMap;
      }
    } else if (_debt.isPaidToMe) {
      final int payIndex = _payablesDebts.indexWhere(
        (de) => de['id'] == debt.id,
      );

      if (payIndex != -1) {
        _payablesDebts[payIndex] = debtMap;
      }
    }
    return true;
  }

  // static Future<List<clsdebtt>> _convertToDebtsList(
  //   List<Map<dynamic, dynamic>> data,
  // ) async {
  //   //_TypeError (type 'Future<clsdebtt?>' is not a subtype of type 'clsdebtt')
  //   List<clsdebtt> debtsList = [];
  //   for (var mapItem in data) {
  //     debtsList.add(await clsdebtt._getfromMap(mapItem));
  //   }
  //   return debtsList;
  // }

  Future<clsDebt?> _getDebtFromMap(Map map) async {
    clsPerson? person = await clsPersonProvider().FindByID(map['personID']);
    if (person == null) return null;

    clsDebt debtData = clsDebt(
      id: map['id'],
      personID: map['personID'],
      amount: map['amount'],
      paidAmount: map['paidAmount'],
      isPaidToMe: map['isPaidToMe'] == 1,
      isSettled: map['isSettled'] == 1,
      date: map['date'],
      note: map['note'],
      updatedAt: map['updateAt'],
      person: person,
    );
    return debtData;
  }

  static clsDebt getStandardDebtFromMap(Map map) {
    clsDebt debtData = clsDebt(
      id: map['id'],
      personID: map['personID'],
      amount: map['amount'],
      paidAmount: map['paidAmount'],
      isPaidToMe: map['isPaidToMe'] == 1,
      isSettled: map['isSettled'] == 1,
      date: map['date'],
      note: map['note'],
      updatedAt: map['updateAt'],
      person: clsPerson.empty(),
    );
    return debtData;
  }

  Future<clsDebt?> FindByID(String debtID) async {
    Map<dynamic, dynamic>? data = await clsDebts_data.FindByID(debtID);

    return data == null ? null : await _getDebtFromMap(data);
  }

  Future<String> _addNew() async {
    String newID = const Uuid().v4();
    int result = await clsDebts_data.insert(
      id: newID,
      personID: _debt.personID,
      amount: _debt.amount,
      paidAmount: _debt.paidAmount,
      isPaidToMe: _debt.isPaidToMe,
      isSettled: _debt.isSettled,
      date: _debt.date,
      note: _debt.note,
    );

    if (result > 0) {
      _debt.id = newID;
      return newID;
    }

    return "-1";
  }

  Future<String> _update() async {
    int UpdatedID = await clsDebts_data.update(
      _debt.id!,
      _debt.personID,
      _debt.amount,
      _debt.paidAmount,
      _debt.isPaidToMe,
      _debt.isSettled,
      _debt.date,
      _debt.note,
    );
    if (UpdatedID > 0) {
      return _debt.id!;
    }
    return "-1";
  }

  Future<String> save() async {
    if (_debt.mode == enMode.AddNew) {
      String newID = await _addNew();
      if (newID != "-1") {
        _debt.mode = enMode.Updated;

        await _addNewToDebts();
        notifyListeners();
        return newID;
      }
      return newID;
    } else {
      String updateResult = await _update();
      if (updateResult != "-1") {
        await _updateDebtToDebts();

        notifyListeners();
      }

      return updateResult;
    }
  }

  void _deleteFromDebts() {
    _Debts.removeWhere((de) => de['id'] == _debt.id);

    if (_debt.isPaidToMe) {
      _receivablesDebts.removeWhere((de) => de['id'] == _debt.id);
      return;
    }
    _payablesDebts.removeWhere((de) => de['id'] == _debt.id);
  }

  Future<bool> delete(String debtID) async {
    clsDebt? debtData = await FindByID(debtID);
    if (debtData == null) return false;
    setDebtInfo(debtData);

    if (await clsDebts_data.delete(debtID) > 0) {
      _deleteFromDebts();
      reducingDebtsSumsRemaining(_debt.remaining);
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> setDelete(String debtID) async {
    clsDebt? debtData = await FindByID(debtID);
    if (debtData == null) return false;
    setDebtInfo(debtData);

    await clsDebts_data.markForDelete(
      debtID: debtID,
      personID: debtData.personID,
    );
    await clsPayments_data.markForDeleteByDebtID(debtID);
    await clsTransactions_data.markForDeleteByDebtID(debtID);
    _deleteFromDebts();
    reducingDebtsSumsRemaining(_debt.remaining);
    notifyListeners();
    return true;
  }

  Future<bool> settle(String debtID) async {
    clsDebt? debtData = await FindByID(debtID);
    if (debtData == null) return false;

    if (debtData.isSettled) return false;

    setDebtInfo(debtData);

    if (await clsDebts_data.settle(debtID) > 0) {
      reducingDebtsSumsRemaining(_debt.remaining);

      _debt.paidAmount = _debt.amount;
      _debt.isSettled = true;

      await _updateDebtToDebts();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<double> getSumPayables() {
    return clsDebts_data.getSumPayables();
  }

  Future<double> getSumRecievables() {
    return clsDebts_data.getSumReciveables();
  }

  // Future<bool> settleCurrentDebt() async {
  //   clsDebt? debtData = await FindByID(_debt.id!);
  //   if (debtData == null) return false;
  //   if (await clsDebts_data.settle(_debt.id!) > 0) {
  //     _debt.paidAmount = _debt.amount;
  //     _debt.isSettled = true;
  //     _updateDebtToDebts();
  //     notifyListeners();
  //   }
  //   return _debt.isSettled;
  // }
}
