import 'package:expenses4/data/local/sql_db.dart';

// id INTEGER PRIMARY KEY AUTOINCREMENT,
//     amount REAL NOT NULL,
//     debtID INTEGER NOT NULL,
//     date TEXT NOT NULL
class clsPayments_data {
  static Future<List<Map<dynamic, dynamic>>> getAllPayments() async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData('''
    SELECT 
      payments.date,
      people.fullname,
      people.imagepath,
      payments.amount,
      debts.isPaidToMe
    FROM `payments` 
    JOIN debts ON payments.debtID = debts.id
    JOIN people ON debts.personID = people.id
      WHERE payments.isDeleted = 0

    ORDER BY payments.id DESC
  ''');
    return data;
  }

  // static Future<List<Map<dynamic, dynamic>>> getLast5Transactions() async {
  //   List<Map<dynamic, dynamic>> data = await SQLDB().readData('''
  //   SELECT
  //     payments.date,
  //     people.fullname,
  //     people.imagepath,
  //     payments.amount,
  //     debts.isPaidToMe
  //   FROM `payments`
  //   JOIN debts ON payments.debtID = debts.id
  //   JOIN people ON debts.personID = people.id
  //     WHERE payments.isDeleted = 0
  //   ORDER BY payments.id DESC
  //   LIMIT 5
  // ''');
  //   return data;
  // }

  static Future<Map<dynamic, dynamic>?> FindByID(String id) async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      'SELECT * FROM `payments` WHERE id = ?',
      [id],
    );
    return data.firstOrNull;
  }

  static Future<List<Map<dynamic, dynamic>>> getPaymentsByDebtID(
    String debtID,
  ) async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      'SELECT payments.*, people.fullname FROM payments '
      'JOIN debts ON payments.debtID = debts.id '
      'JOIN people ON debts.personID = people.id '
      'WHERE payments.debtID = ? '
      'ORDER BY payments.updateAt DESC',
      [debtID],
    );
    return data;
  }

  static Future<int> insert({
    required String paymentID,
    required double amount,
    required String debtID,
    required String date,
    String? updateAt,
    bool isSynced = false,
  }) async {
    int resultID = await SQLDB().insertData(
      '''
      INSERT INTO `payments` (id, amount, debtID, date, isSynced, updateAt)
      VALUES (?, ?, ?, ?, ?, ?)
    ''',
      [
        paymentID,
        amount,
        debtID,
        date,
        isSynced ? 1 : 0,
        updateAt ?? DateTime.now().toIso8601String(),
      ],
    );

    return resultID;
  }

  static Future<int> update(
    String id,
    double amount,
    String debtID,
    String date, {
    bool isSynced = false,
  }) async {
    return await SQLDB().updateData(
      '''
      UPDATE `payments` SET
        amount = ?,
        debtID = ?,
        date = ?,
        isSynced = ?
      WHERE id = ?
    ''',
      [amount, debtID, date, isSynced ? 1 : 0, id],
    );
  }

  static Future<bool> isExist(String id) async {
    final result = await SQLDB().readData(
      'SELECT 1 FROM payments WHERE id = ? LIMIT 1',
      [id],
    );

    return result.isNotEmpty;
  }

  static Future<int> markForDelete(String id) async {
    return await SQLDB().updateData(
      '''
      UPDATE `payments` SET
        isDeleted = 1, isSynced = 0
      WHERE id = ?
      ''',
      [id],
    );
  }

  static Future<int> markForDeleteByDebtID(String debtID) async {
    return await SQLDB().updateData(
      '''
      UPDATE `payments` SET
        isDeleted = 1, isSynced = 0
      WHERE debtID = ?
      ''',
      [debtID],
    );
  }

  // static Future<List<String>> getIDsPaymentsByDebtID(String debtID) async {
  //   List<Map> deletedPaymentsIDs = await SQLDB().readData(
  //     'SELECT id FROM `payments` WHERE debtID = ?',
  //     [debtID],
  //   );
  //   List<String> strPaymentsIDs = [];
  //   for (Map payment in deletedPaymentsIDs) {
  //     strPaymentsIDs.add(payment['id'].toString());
  //   }

  //   return strPaymentsIDs;
  // }

  static Future<List<Map>> getIDsDeletedPayments() async {
    return await SQLDB().readData(
      'SELECT id FROM `payments` WHERE isDeleted = 1',
    );
    // List<String> strDeletedPaymentsIDs = [];
    // for (Map payment in deletedPaymentsIDs) {
    //   strDeletedPaymentsIDs.add(payment['id'].toString());
    // }
    // return strDeletedPaymentsIDs;
  }

  static Future<int> markForSync(String id) async {
    return await SQLDB().updateData(
      '''
      UPDATE payments SET
        isSynced = 1
      WHERE id = ?
      ''',
      [id],
    );
  }

  static Future<List<Map>> getUnsyncedPayments() async {
    return await SQLDB().readData('SELECT * FROM payments WHERE isSynced = 0');
  }

  static Future<int> delete(String id) async {
    return await SQLDB().deleteData('DELETE FROM `payments` WHERE id = ?', [
      id,
    ]);
  }

  static Future<void> setAllUnSync() async {
    await SQLDB().updateData('''
               UPDATE `payments` SET
              isSynced = 0
              ''');
  }
}
