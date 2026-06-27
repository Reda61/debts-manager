import 'package:sqflite/sqflite.dart';

class SQLDB {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initialDB();
    return _db!;
  }

  initialDB() async {
    String databasePath = await getDatabasesPath();
    String path = '$databasePath/expenses4.db';

    //clear local data
    // await deleteDatabase(path);
    // final prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    // return;
    //clear local data

    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      version: 6,
      onUpgrade: _onupgrade,
    );
    return mydb;
  }

  Future<void> _onupgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 6) {
      // await db.execute(
      //   'ALTER TABLE `transactions` ADD COLUMN paymentID INTEGER NOT NULL',
      // );
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE people (
    id TEXT PRIMARY KEY,
    fullname TEXT NOT NULL,
    imagepath TEXT NULL,
    phone TEXT NULL,
    isSynced INTEGER NOT NULL DEFAULT 0,
    isDeleted INTEGER NOT NULL DEFAULT 0,
    updateAt TEXT NOT NULL
  )
''');

    await db.execute('''
  CREATE TABLE debts (
    id TEXT PRIMARY KEY,
    personID TEXT NOT NULL,
    amount REAL NOT NULL,
    paidAmount REAL NOT NULL,
    isPaidToMe INTEGER NOT NULL,
    isSettled INTEGER NOT NULL,
    date TEXT NOT NULL,
    note TEXT,
    isSynced INTEGER NOT NULL DEFAULT 0,
    isDeleted INTEGER NOT NULL DEFAULT 0,
    updateAt TEXT NOT NULL,
    FOREIGN KEY (personID) REFERENCES people(id) ON DELETE CASCADE
  )
''');

    await db.execute('''
  CREATE TABLE `payments` (
    id TEXT PRIMARY KEY,
    amount REAL NOT NULL,
    date TEXT NOT NULL,
    debtID TEXT NOT NULL,
    isSynced INTEGER NOT NULL DEFAULT 0,
    isDeleted INTEGER NOT NULL DEFAULT 0,
    updateAt TEXT NOT NULL,
    FOREIGN KEY (debtID) REFERENCES debts(id) ON DELETE CASCADE
  )
''');

    await db.execute('''
  CREATE TABLE `transactions` (
    id TEXT PRIMARY KEY,
    amount REAL NOT NULL,
    date TEXT NOT NULL,
    debtID TEXT NOT NULL,
    paymentID TEXT NOT NULL,
    isSynced INTEGER NOT NULL DEFAULT 0,
    isDeleted INTEGER NOT NULL DEFAULT 0,
    updateAt TEXT NOT NULL,
    FOREIGN KEY (debtID) REFERENCES debts(id) ON DELETE CASCADE,
    FOREIGN KEY (paymentID) REFERENCES payments(id) ON DELETE CASCADE
  )
''');
  }

  //this has been changed to insertMap to handle null values properly without needing to check them in the calling code
  Future<int> insertData(String sql, [List<dynamic> args = const []]) async {
    Database? mydb = await db;
    int response = await mydb.rawInsert(sql, args);
    return response;
  }

  Future<List<Map>> readData(
    String sql, [
    List<dynamic> args = const [],
  ]) async {
    Database? mydb = await db;
    List<Map> response = await mydb.rawQuery(sql, args);
    return response;
  }

  Future<int> updateData(String sql, [List<dynamic> args = const []]) async {
    Database? mydb = await db;
    int response = await mydb.rawUpdate(sql, args);
    return response;
  }

  Future<int> deleteData(String sql, [List<dynamic> args = const []]) async {
    Database? mydb = await db;
    int response = await mydb.rawDelete(sql, args);
    return response;
  }

  Future<int> clearTable(String table) async {
    final database = await db;
    return await database.delete(table);
  }
}
