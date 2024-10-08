import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'gempa.db'),
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE gempa(id INTEGER PRIMARY KEY AUTOINCREMENT, coordinates TEXT, magnitude TEXT, kedalaman TEXT, tanggal TEXT, jam TEXT, lintang TEXT, bujur TEXT)'''
        );
      },
      version: 1,
    );
  }

  Future<void> insertGempa(Map<String, dynamic> gempa) async {
    final db = await database;
    await db.insert(
      'gempa',
      gempa,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getGempaData() async {
    final db = await database;
    return await db.query('gempa');
  }

  Future<void> deleteGempaData() async {
    final db = await database;
    await db.delete('gempa');
  }
}
