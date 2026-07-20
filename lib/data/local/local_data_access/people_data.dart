import 'package:expenses4/data/local/sql_db.dart';

// id INTEGER PRIMARY KEY AUTOINCREMENT,
//     fullname  TEXT NOT NULL,
//     imagepath TEXT NULL,
//     phone     TEXT NULL

class clsPeople_data {
  static Future<List<Map>> getAllPeople() async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      'SELECT * FROM people where isDeleted = 0',
    );
    return data;
  }

  static Future<Map<dynamic, dynamic>?> FindByID(String personID) async {
    List<Map<dynamic, dynamic>> data = await SQLDB().readData(
      'SELECT * FROM people WHERE id = ?',
      [personID],
    );
    return data.firstOrNull;
  }

  static Future<int> insert({
    required String id,
    required String fullname,
    String? phone,
    String? imagepath,
    String? updateAt,
    bool isSynced = false,
  }) async {
    return await SQLDB().insertData(
      '''
      INSERT INTO people (id, fullname, phone, imagepath, isSynced, updateAt)
      VALUES (?, ?, ?, ?, ?, ?)
       ''',
      [
        id,
        fullname,
        phone,
        imagepath,
        isSynced ? 1 : 0,
        updateAt ?? DateTime.now().toIso8601String(),
      ],
    );
  }

  static Future<int> update(
    String id,
    String fullname,
    String? phone,
    String? imagepath, {
    bool isSynced = false,
  }) async {
    return await SQLDB().updateData(
      '''
      UPDATE people SET
        fullname = ?,
        phone = ?,
        imagepath = ?,
        isSynced = ?
      WHERE id = ?
      ''',
      [fullname, phone, imagepath, isSynced ? 1 : 0, id],
    );
  }

  static Future<int> markForDelete(String id) async {
    return await SQLDB().updateData(
      '''
      UPDATE people SET
        isDeleted = 1, isSynced = 0
      WHERE id = ?
      ''',
      [id],
    );
  }

  static Future<List<Map>> getAllUnsyncedPeople() async {
    List<Map> data = await SQLDB().readData('''SELECT * FROM people 
       WHERE isSynced = 0''');
    return data;
  }

  static Future<int> markForSync(String id) async {
    return await SQLDB().updateData(
      '''
      UPDATE people SET
        isSynced = 1
      WHERE id = ?
      ''',
      [id],
    );
  }

  // static Future<List<String>> getIDsDeletedPeople() async {
  //   List<Map> deletedPeopleIDs = await SQLDB().readData(
  //     'SELECT id FROM `people` WHERE isDeleted = 1',
  //   );
  //   List<String> strDeletedPeopleIDs = [];
  //   for (Map person in deletedPeopleIDs) {
  //     strDeletedPeopleIDs.add(person['id'].toString());
  //   }

  //   return strDeletedPeopleIDs;
  // }

  static Future<List<Map>> getDeletedPeople() async {
    return await SQLDB().readData(
      'SELECT id FROM `people` WHERE isDeleted = 1',
    );
  }

  static Future<bool> isPeopleDataExist() async {
    final result = await SQLDB().readData('SELECT id FROM `people` LIMIT 1');
    return result.isNotEmpty;
  }

  static Future<int> delete(String id) async {
    return await SQLDB().deleteData('DELETE FROM people WHERE id = ?', [id]);
  }

  static Future<bool> isExist(String id) async {
    final result = await SQLDB().readData(
      'SELECT 1 FROM people WHERE id = ? LIMIT 1',
      [id],
    );

    return result.isNotEmpty;
  }

  static Future<void> setAllUnSync() async {
    await SQLDB().updateData('''
               UPDATE `people` SET
              isSynced = 0
              ''');
  }

  // await SQLDB().updateData('''
  //     UPDATE people SET
  //       isSynced = 0
  //     ''');
}
