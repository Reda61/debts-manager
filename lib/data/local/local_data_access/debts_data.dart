import 'package:expenses4/data/local/local_data_access/people_data.dart';
import 'package:expenses4/data/local/sql_db.dart';
import 'package:uuid/uuid.dart';

class clsDebts_data {
  static Future<List<Map<dynamic, dynamic>>> getAllDebts() async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData('''
    SELECT 
      debts.id,
      debts.personID,
      debts.amount,
      debts.paidAmount,
      debts.isPaidToMe,
      debts.isSettled,
      debts.date,
      people.fullname,
      people.imagepath
      FROM debts
      INNER JOIN people ON debts.personID = people.id
      WHERE debts.isDeleted = 0
      ORDER BY isSettled , debts.updateAt desc
    ''');
    return data;
  }

  static Future<List<Map<dynamic, dynamic>>> getReceivables() async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData('''
    SELECT 
      debts.id,
      debts.personID,
      debts.amount,
      debts.paidAmount,
      debts.isPaidToMe,
      debts.isSettled,
      debts.date,
      people.fullname,
      people.imagepath
      FROM debts
      INNER JOIN people ON debts.personID = people.id
      where isPaidToMe = 1
      AND debts.isDeleted = 0
      ORDER BY isSettled , debts.updateAt desc
    ''');
    return data;
  }

  static Future<List<Map<dynamic, dynamic>>> getPayables() async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData('''
    SELECT 
      debts.id,
      debts.personID,
      debts.amount,
      debts.paidAmount,
      debts.isPaidToMe,
      debts.isSettled,
      debts.date,
      people.fullname,
      people.imagepath
      FROM debts
      INNER JOIN people ON debts.personID = people.id
      where isPaidToMe = 0
      AND debts.isDeleted = 0
      ORDER BY isSettled , debts.updateAt desc
    ''');
    return data;
  }

  static Future<Map<dynamic, dynamic>?> getByPerson(String personID) async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      'SELECT * FROM debts WHERE personID = ?',
      [personID],
    );
    return data.firstOrNull;
  }

  static Future<Map<dynamic, dynamic>?> FindByID(String id) async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      'SELECT * FROM debts WHERE id = ?',
      [id],
    );
    return data.firstOrNull;
  }

  static Future<int> insert({
    required String id,
    required String personID,
    required double amount,
    required double paidAmount,
    required bool isPaidToMe,
    required bool isSettled,
    required String date,
    String? updateAt,
    String? note,
    bool isSynced = false,
  }) async {
    return await SQLDB().insertData(
      '''INSERT INTO debts (id, personID, amount, paidAmount, isPaidToMe, isSettled, date, note, isSynced,updateAt)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
      [
        id,
        personID,
        amount,
        paidAmount,
        isPaidToMe ? 1 : 0,
        isSettled ? 1 : 0,
        date,
        note,
        isSynced ? 1 : 0,
        updateAt ?? DateTime.now().toIso8601String(),
      ],
    );
  }

  static Future<int> update(
    String id,
    String personID,
    double amount,
    double paidAmount,
    bool isPaidToMe,
    bool isSettled,
    String date,
    String? note, {
    bool isSynced = false,
  }) async {
    return await SQLDB().updateData(
      '''UPDATE debts SET
           amount = ?,
           paidAmount = ?,
           isPaidToMe = ?,
           isSettled = ?,
           date = ?,
           note = ?,
           isSynced = ?
         WHERE id = ?''',
      [
        amount,
        paidAmount,
        isPaidToMe ? 1 : 0,
        isSettled ? 1 : 0,
        date,
        note,
        isSynced ? 1 : 0,
        id,
      ],
    );
  }

  static Future<int> delete(String id) async {
    return await SQLDB().deleteData('DELETE FROM debts WHERE id = ?', [id]);
  }

  static Future<void> markForDelete({
    required String debtID,
    required String personID,
  }) async {
    await clsPeople_data.markForDelete(personID);

    await SQLDB().updateData(
      '''
         UPDATE debts SET
           isDeleted = 1 ,isSynced = 0
         WHERE id = ?
      ''',
      [debtID],
    );
  }

  static Future<int> markForSync(String id) async {
    return await SQLDB().updateData(
      '''
      UPDATE debts SET
        isSynced = 1
      WHERE id = ?
      ''',
      [id],
    );
  }

  static Future<int> settle(String debtID) async {
    //1 Get debt remaining amount
    List<Map> debt = await SQLDB().readData(
      'SELECT amount - paidAmount as remaining FROM debts WHERE id = ?',
      [debtID],
    );

    double remaining = debt[0]['remaining'];

    //2 Insert payment
    String newPaymentID = const Uuid().v4();
    int insertResult = await SQLDB().insertData(
      'INSERT INTO payments (id, amount, debtID, date, updateAt) VALUES (?, ?, ?, ?, ?)',
      [
        newPaymentID,
        remaining,
        debtID,
        DateTime.now().toString().substring(0, 10),
        DateTime.now().toIso8601String(),
      ],
    );

    //3 Insert Transaction
    if (insertResult < 1) return -1;
    String newTransactionID = const Uuid().v4();
    insertResult = await SQLDB().insertData(
      'INSERT INTO `transactions` (id, amount, debtID, paymentID, date, updateAt) VALUES (?, ?, ?, ?, ?, ?)',
      [
        newTransactionID,
        remaining,
        debtID,
        newPaymentID,
        DateTime.now().toString().substring(0, 10),
        DateTime.now().toIso8601String(),
      ],
    );

    //4 Settle Debt
    if (insertResult < 1) return -1;
    return await SQLDB().updateData(
      'UPDATE debts SET isSettled = 1, paidAmount = amount,isSynced = 0 WHERE id = ?',
      [debtID],
    );
  }

  static Future<List<Map>> getAllUnsyncedDebts() async {
    List<Map> data = await SQLDB().readData('''SELECT * FROM debts 
       WHERE isSynced = 0
       ORDER BY id''');
    return data;
  }

  static Future<List<Map>> getDeletedDebts() async {
    return await SQLDB().readData('SELECT id FROM `debts` WHERE isDeleted = 1');
  }

  static Future<double> getSumReciveables() async {
    double sumReciveables;
    List<Map> sumReciveablesList = await SQLDB().readData('''
        SELECT sum(amount- paidAmount) AS sum FROM debts WHERE isPaidToMe = 1
        and isDeleted = 0
        ''');
    sumReciveables = double.parse(
      (sumReciveablesList[0]['sum'] ?? 0).toString(),
    );
    return sumReciveables;
  }

  static Future<double> getSumPayables() async {
    double sumReciveables;
    List<Map> sumReciveablesList = await SQLDB().readData('''
        SELECT sum(amount - paidAmount) AS sum FROM debts WHERE isPaidToMe = 0
        and isDeleted = 0
        ''');
    sumReciveables = double.parse(
      (sumReciveablesList[0]['sum'] ?? 0).toString(),
    );
    return sumReciveables;
  }

  static Future<List<Map>> searchAllDebts(String query) async {
    return await SQLDB().readData(
      '''
       SELECT debts.*, people.fullname, people.imagepath
       FROM debts
       JOIN people ON debts.personID = people.id
       WHERE people.fullname LIKE ? 
       and debts.isDeleted = 0
       order by isSettled, updateAt desc
      ''',
      ['$query%'],
    );
  }

  static Future<List<Map>> searchPayDebts(String query) async {
    return await SQLDB().readData(
      '''
      SELECT debts.*, people.fullname, people.imagepath
      FROM debts
      JOIN people ON debts.personID = people.id
      WHERE debts.isPaidToMe = 0 and people.fullname LIKE ? 
        and debts.isDeleted = 0
      order by isSettled, updateAt desc
      ''',
      ['$query%'],
    );
  }

  static Future<bool> isExist(String id) async {
    final result = await SQLDB().readData(
      'SELECT 1 FROM debts WHERE id = ? LIMIT 1',
      [id],
    );

    return result.isNotEmpty;
  }

  static Future<List<Map>> searchRecievDebts(String query) async {
    return await SQLDB().readData(
      '''
      SELECT debts.*, people.fullname, people.imagepath
      FROM debts
      JOIN people ON debts.personID = people.id
      WHERE debts.isPaidToMe = 1 and people.fullname LIKE ? 
        and debts.isDeleted = 0
      order by isSettled, updateAt desc
     ''',
      ['$query%'],
    );
  }

  static Future<void> setAllUnSync() async {
    await SQLDB().updateData('''
               UPDATE `debts` SET
              isSynced = 0
              ''');
  }
}
