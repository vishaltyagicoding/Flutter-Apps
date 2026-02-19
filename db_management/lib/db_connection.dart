import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbConnection {
  // Singleton instance
  static final DbConnection instance = DbConnection._internal();

  // Private constructor
  DbConnection._internal();

  // Factory constructor
  factory DbConnection() {
    return instance;
  }

  // Database instance
  static Database? _database;

  // Table details
  static const String tableName = 'daily_notes';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnSubtitle = 'subtitle';
  static const String columnDate = 'date';
  static const String columnCreatedAt = 'created_at';

  // Initialize database
  Future<Database> _initDatabase() async {
    try {
      // Get database path
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'daily_notes.db');

      print("Database path: $path");

      // Open/create database
      return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE $tableName (
              $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnTitle TEXT NOT NULL,
              $columnSubtitle TEXT,
              $columnDate TEXT NOT NULL,
              $columnCreatedAt TEXT NOT NULL
            )
          ''');
          print("Table created successfully");
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  // Get database (lazy initialization)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Add a daily note
  Future<int> addNote({
    required String title,
    required String subtitle,
    required String date,
  }) async {
    try {
      final db = await database;

      final result = await db.insert(tableName, {
        columnTitle: title,
        columnSubtitle: subtitle,
        columnDate: date,
        columnCreatedAt: DateTime.now().toIso8601String(),
      });

      print("Note added with ID: $result");
      return result;
    } catch (e) {
      print("Error adding note: $e");
      rethrow;
    }
  }

  // Get all notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    try {
      final db = await database;
      return await db.query(tableName, orderBy: '$columnDate DESC');
    } catch (e) {
      print("Error getting notes: $e");
      rethrow;
    }
  }

  // Get notes by date
  Future<List<Map<String, dynamic>>> getNotesByDate(String date) async {
    try {
      final db = await database;
      return await db.query(
        tableName,
        where: '$columnDate = ?',
        whereArgs: [date],
        orderBy: '$columnCreatedAt DESC',
      );
    } catch (e) {
      print("Error getting notes by date: $e");
      rethrow;
    }
  }

  // Update a note
  Future<int> updateNote({
    required int id,
    required String title,
    required String subtitle,
  }) async {
    try {
      final db = await database;
      return await db.update(
        tableName,
        {columnTitle: title, columnSubtitle: subtitle},
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating note: $e");
      rethrow;
    }
  }

  // Delete a note
  Future<int> deleteNote(int id) async {
    try {
      final db = await database;
      return await db.delete(
        tableName,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting note: $e");
      rethrow;
    }
  }

  // Close database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
