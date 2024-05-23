import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String glassTable = 'glass_table';
  String colId = 'id';
  String colName = 'name';
  String colBrewery = 'brewery';
  String colComment = 'comment';
  String colAmount = 'amount';
  String colRating = 'rating';
  String colServeStyle = 'serve_style';
  String colFlavorProfile = 'flavor_profile';
  String colImagePath = 'image_path';

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'glasses.db');
    final glassesDb = await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
    return glassesDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $glassTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colBrewery TEXT, $colComment TEXT, $colAmount INTEGER, $colRating REAL, $colServeStyle TEXT, $colFlavorProfile TEXT, $colImagePath TEXT)',
    );
  }

  void _upgradeDb(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $glassTable ADD COLUMN $colAmount INTEGER',
      );
    }
  }

  Future<int> insertGlass(Map<String, dynamic> glass) async {
    Database? db = await this.db;
    final int result = await db!.insert(glassTable, glass);
    return result;
  }

  Future<int> updateGlass(Map<String, dynamic> glass) async {
    Database? db = await this.db;
    final int result = await db!.update(
      glassTable,
      glass,
      where: '$colId = ?',
      whereArgs: [glass['id']],
    );
    return result;
  }

  Future<int> deleteGlass(int id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      glassTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getGlasses() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(glassTable);
    return result;
  }

  Future<int> getTotalGlasses() async {
    Database? db = await this.db;
    var result = await db!.rawQuery('SELECT COUNT(*) FROM $glassTable');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getUniqueGlasses() async {
    Database? db = await this.db;
    var result = await db!.rawQuery('SELECT COUNT(DISTINCT $colName) FROM $glassTable');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> deleteDatabaseFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'glasses.db');
    File file = File(path);

    if (await file.exists()) {
      await file.delete();
      print('Database deleted: $path');
    } else {
      print('Database file does not exist.');
    }
  }
}
