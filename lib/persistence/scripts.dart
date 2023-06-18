import 'package:atm_project/model/accountUpdate.dart';
import 'package:atm_project/model/account_Model.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/transacoes.dart';

class DBHelper {
  static Future<Database> database() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'teste.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE IF NOT EXISTS Account (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            pin TEXT,
            balance TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE IF NOT EXISTS Transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            accountId INTEGER,
            balance TEXT,
            type TEXT,
            FOREIGN KEY (accountId) REFERENCES Account (id)
          )
        ''');
      },
      version: 3,
    );
    return database;
  }

  static Future<void> insertUser(Account usersModel) async {
    var database = await DBHelper.database();
    final db = database;

    await db.insert(
      'Account',
      usersModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Account?> getUser(String user) async {
    var database = DBHelper.database();
    final db = await database;

    await db.query(
      'Account',
      where: 'name = ?',
      whereArgs: [user],
    );
    return null;
  }

  static Future<void> updateAccount(AccountUpdate account) async {
    var database = DBHelper.database();
    final db = await database;

    await db.update(
      'Account',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  static Future<void> inserirTransacoes(Transacoes transacoes) async {
    var database = DBHelper.database();
    final db = await database;

    await db.insert(
      'Transactions',
      transacoes.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Transacoes>> getTransactionsByAccount(
      int accountId) async {
    var database = DBHelper.database();
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'Transactions',
      where: 'accountId = ?',
      whereArgs: [accountId],
    );

    return List.generate(maps.length, (index) {
      return Transacoes(
        id: maps[index]['id'],
        accountId: maps[index]['accountId'],
        type: maps[index]['type'],
        balance: double.parse(maps[index]['balance'].toString()),
      );
    });
  }
}
