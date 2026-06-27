import 'package:expenses4/data/local/sql_db.dart';

// id INTEGER PRIMARY KEY AUTOINCREMENT,
//     amount REAL NOT NULL,
//     debtID INTEGER NOT NULL,
//     date TEXT NOT NULL
class clsTransactions_data {
  static Future<List<Map<dynamic, dynamic>>> getAllTransactions() async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData('''
    SELECT 
      transactions.*,
      people.fullname,
      people.imagepath,
      debts.isPaidToMe
    FROM `transactions` 
    JOIN debts ON transactions.debtID = debts.id
    JOIN people ON debts.personID = people.id
    WHERE transactions.isDeleted = 0
    ORDER BY transactions.updateAt DESC
  ''');
    return data;
  }

  static Future<List<Map>> searchByPersonName(String query) async {
    // await Future.delayed(Duration(milliseconds: 300));
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      '''
    SELECT 
      transactions.*,
      people.fullname,
      people.imagepath,
      debts.isPaidToMe
    FROM `transactions` 
    JOIN debts ON transactions.debtID = debts.id
    JOIN people ON debts.personID = people.id 
    where people.fullname like ?
    AND transactions.isDeleted = 0
    ORDER BY transactions.updateAt DESC
  ''',
      ['$query%'],
    );
    return data;
  }

  static Future<List<Map>> getLast5Transactions() async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData('''
    SELECT 
      transactions.*,
      people.fullname,
      people.imagepath,
      debts.isPaidToMe
    FROM `transactions` 
    JOIN debts ON transactions.debtID = debts.id
    JOIN people ON debts.personID = people.id
     WHERE transactions.isDeleted = 0
    ORDER BY transactions.updateAt DESC
    LIMIT 5
  ''');
    return data;
  }

  static Future<Map<dynamic, dynamic>?> FindByID(String id) async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      'SELECT * FROM `transactions` WHERE id = ?',
      [id],
    );
    return data.firstOrNull;
  }

  static Future<List<Map>> getTransactionsByDebtID(int debtID) async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      '''
      SELECT transactions.*,
       people.fullname FROM transactions 
      JOIN debts ON transactions.debtID = debts.id 
      JOIN people ON debts.personID = people.id 
      WHERE transactions.debtID = ? 
      AND transactions.isDeleted = 0
      ORDER BY transactions.updateAt DESC''',
      [debtID],
    );
    return data;
  }

  static Future<int> insert({
    required String id,
    required double amount,
    required String debtID,
    required String paymentID,
    required String date,
    String? updateAt,
    bool isSynced = false,
  }) async {
    print("----------------------------INSERT ERRO Statr");

    return await SQLDB()
        .insertData(
          '''
      INSERT INTO `transactions` (id, amount, debtID, paymentID, date, isSynced, updateAt)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''',
          [
            id,
            amount,
            debtID,
            paymentID,
            date,
            isSynced ? 1 : 0,
            updateAt ?? DateTime.now().toIso8601String(),
          ],
        )
        .catchError((e) {
          print("----------------------------INSERT ERROR: $e");
          return 0;
        });
  }

  static Future<bool> isExist(String id) async {
    final result = await SQLDB().readData(
      'SELECT 1 FROM `transactions` WHERE id = ? LIMIT 1',
      [id],
    );

    return result.isNotEmpty;
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
      UPDATE `transactions` SET
        amount = ?,
        debtID = ?,
        date = ?,
        isSynced = ?
      WHERE id = ?
    ''',
      [amount, debtID, date, isSynced ? 1 : 0, id],
    );
  }

  static Future<int> markForSync(String id) async {
    return await SQLDB().updateData(
      '''
      UPDATE `transactions` SET
        isSynced = 1
      WHERE id = ?
      ''',
      [id],
    );
  }

  static Future<List<Map>> getUnsyncedTransactions() async {
    return await SQLDB().readData(
      'SELECT * FROM `transactions` WHERE isSynced = 0',
    );
  }

  static Future<List<Map>> getIDsDeletedTransactions() async {
    return await SQLDB().readData(
      'SELECT id FROM `transactions` WHERE isDeleted = 1',
    );
  }

  static Future<int> markForDeleteByDebtID(String debtID) async {
    return await SQLDB().updateData(
      '''
      UPDATE `transactions` SET
        isDeleted = 1, isSynced = 0
      WHERE debtID = ?
      ''',
      [debtID],
    );
  }

  static Future<int> markForDelete(String id) async {
    return await SQLDB().updateData(
      '''
      UPDATE `transactions` SET
        isDeleted = 1, isSynced = 0
      WHERE id = ?
      ''',
      [id],
    );
  }

  //  static Future<List<String>> getIDsPaymentsByDebtID(String debtID) async {
  //     List<Map> deletedPaymentsIDs = await SQLDB().readData(
  //       'SELECT id FROM `transactions` WHERE debtID = ?',[debtID]
  //     );
  //     List<String> strPaymentsIDs = [];
  //     for (Map payment in deletedPaymentsIDs) {
  //       strPaymentsIDs.add(payment['id'].toString());
  //     }

  //     return strPaymentsIDs;
  //   }

  static Future<int> delete(String id) async {
    return await SQLDB().deleteData('DELETE FROM `transactions` WHERE id = ?', [
      id,
    ]);
  }

  static Future<void> setAllUnSync() async {
    await SQLDB().updateData('''
               UPDATE `transactions` SET
              isSynced = 0
              ''');
  }
}
