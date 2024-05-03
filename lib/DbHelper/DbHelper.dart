import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE Products(id INTEGER PRIMARY KEY, productName TEXT, cartCount INTEGER)',
        );
      },
    );
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('Products', data);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db.query('Products');
  }

  Future<int> updateData(int id, Map<String, dynamic> newData) async {
    final db = await database;
    return await db.update(
      'Products',
      newData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
