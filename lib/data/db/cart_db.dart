import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartDatabaseHelper {
  static Database? _database;
  static const _tableName = 'cart_products';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'your_cart_database_name.db');

    return await openDatabase(path, version: 2, onCreate: (db, version) {
      return db.execute('''
CREATE TABLE cart_products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  productId INTEGER,
  title TEXT, 
  price REAL,
  description TEXT,
  category TEXT,
  image TEXT,
  quantity INTEGER DEFAULT 1
)

  ''');
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute('ALTER TABLE $_tableName ADD COLUMN title TEXT');
      }
    });
  }

  Future<void> insertToCart(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert(_tableName, product, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCartProducts() async {
    final db = await database;
    return await db.query(_tableName);
  }

  Future<void> removeFromCart(int productId) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<int?> getQuantityInCart(int productId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      columns: ['quantity'],
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (result.isEmpty) {
      return null;
    } else {
      return result.first['quantity'] as int;
    }
  }

  Future<void> updateProductQuantity(int productId, int newQuantity) async {
    final db = await database;
    await db.update(
      _tableName,
      {'quantity': newQuantity},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> isProductInCart(int productId) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }

  Future<void> updateProductPrice(int productId, double totalPrice) async {
    final db = await database;
    await db.update(
      _tableName,
      {'price': totalPrice},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }
}
