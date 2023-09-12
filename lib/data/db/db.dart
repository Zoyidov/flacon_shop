import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const _likedTableName = 'liked_products';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'your_database_name.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE liked_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        title TEXT,
        price REAL,
        description TEXT,
        category TEXT,
        image TEXT
      )
    ''');
    });
  }

  Future<void> insertLikedProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert(_likedTableName, product,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getLikedProducts() async {
    final db = await database;
    return await db.query(_likedTableName);
  }

  Future<void> deleteLikedProduct(int productId) async {
    final db = await database;
    await db.delete(
      _likedTableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> isProductLiked(int productId) async {
    final db = await database;
    final result = await db.query(
      _likedTableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }
}
