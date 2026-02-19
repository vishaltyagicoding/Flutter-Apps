import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase extends ChangeNotifier {
  static const String tableName = 'expenses';
  static const String columnId = 'id';
  static const String columnItem = 'item';
  static const String columnQty = 'qty';
  static const String columnPrice = 'price';
  static const String columnDate = 'date';
  static const String columnDescription = 'description';

  Database? _database;
  List<Map<String, dynamic>> _allData = [];
  double _totalAmount = 0.0;

  List<Map<String, dynamic>> get allData => _allData;
  double get totalAmount => _totalAmount;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expenses.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnItem TEXT NOT NULL,
            $columnQty TEXT NOT NULL,
            $columnPrice REAL NOT NULL,
            $columnDate TEXT NOT NULL,
            $columnDescription TEXT
          )
        ''');
      },
    );
  }

  Future<void> initialize() async {
    await _refreshData();
  }

  Future<void> insertRow({
    required String dateValue,
    required String itemValue,
    required String qtyValue,
    required double priceValue,
    required String descriptionValue,
  }) async {
    final db = await database;
    await db.insert(tableName, {
      columnItem: itemValue,
      columnQty: qtyValue,
      columnPrice: priceValue,
      columnDate: dateValue,
      columnDescription: descriptionValue,
    });
    await _refreshData();
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;
    return await db.query(tableName, orderBy: '$columnDate DESC');
  }

  Future<void> updateRow({
    required int id,
    required String dateValue,
    required String itemValue,
    required String qtyValue,
    required double priceValue,
    required String descriptionValue,
  }) async {
    final db = await database;
    await db.update(
      tableName,
      {
        columnItem: itemValue,
        columnQty: qtyValue,
        columnPrice: priceValue,
        columnDate: dateValue,
        columnDescription: descriptionValue,
      },
      where: '$columnId = ?',
      whereArgs: [id],
    );
    await _refreshData();
  }

  Future<void> deleteRow(int id) async {
    final db = await database;
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
    await _refreshData();
  }

  Future<void> _refreshData() async {
    _allData = await getAllData();
    _totalAmount = _allData.fold(
      0.0,
      (previousValue, element) =>
          previousValue + (element[columnPrice] as double),
    );
    notifyListeners();
  }
}
