
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CartDbService {
  static Database? _db;

  static const String tableCart = 'cart';
  static const String colFoodId = 'foodId';
  static const String colName = 'name';
  static const String colPrice = 'price';
  static const String colQuantity = 'quantity';

  /// Initialize DB
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  /// Create DB and table
  static Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'cart.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableCart (
            $colFoodId TEXT PRIMARY KEY,
            $colName TEXT,
            $colPrice REAL,
            $colQuantity INTEGER
          )
        ''');
      },
    );
  }

  /// Add or Update Item
  static Future<void> addToCart(Map<String, dynamic> item) async {
    final db = await database;

    final existing = await db.query(
      tableCart,
      where: '$colFoodId = ?',
      whereArgs: [item['id']],
    );

    if (existing.isNotEmpty) {
      final currentQty = (existing.first[colQuantity] as int);
      await db.update(
        tableCart,
        {colQuantity: currentQty + 1},
        where: '$colFoodId = ?',
        whereArgs: [item['id']],
      );
    } else {
      await db.insert(tableCart, {
        colFoodId: item['id'],
        colName: item['name'],
        colPrice: item['price'],
        colQuantity: 1,
      });
    }
  }

  /// Remove an item
  static Future<void> removeFromCart(String foodId) async {
    final db = await database;
    await db.delete(tableCart, where: '$colFoodId = ?', whereArgs: [foodId]);
  }

  /// Increase quantity
  static Future<void> increaseQuantity(String foodId) async {
    final db = await database;
    await db.rawUpdate(
      '''
      UPDATE $tableCart 
      SET $colQuantity = $colQuantity + 1 
      WHERE $colFoodId = ?
      ''',
      [foodId],
    );
  }

  /// Decrease quantity (and remove if < 1)
  static Future<void> decreaseQuantity(String foodId) async {
    final db = await database;
    final item = await db.query(
      tableCart,
      where: '$colFoodId = ?',
      whereArgs: [foodId],
    );

    if (item.isNotEmpty) {
      final currentQty = item.first[colQuantity] as int;
      if (currentQty > 1) {
        await db.update(
          tableCart,
          {colQuantity: currentQty - 1},
          where: '$colFoodId = ?',
          whereArgs: [foodId],
        );
      } else {
        await removeFromCart(foodId);
      }
    }
  }

  /// Get all items
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query(tableCart);
  }

  /// Clear all
  static Future<void> clearCart() async {
    final db = await database;
    await db.delete(tableCart);
  }
}