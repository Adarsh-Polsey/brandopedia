import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CartDbService {
  static Database? _db;

  static const String tableCart = 'cart';
  static const String colId = 'id';
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
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colName TEXT UNIQUE,
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
      where: '$colName = ?',
      whereArgs: [item['name']],
    );

    if (existing.isNotEmpty) {
      try {
        await db.update(
          tableCart,
          {colQuantity: (existing.first[colQuantity] as int) + 1},
          where: '$colName = ?',
          whereArgs: [item['name']],
        );
      } catch (e) {
        log('Error updating item: $e');
        throw Exception('Invalid quantity type');
      }
    } else {
      await db.insert(tableCart, {
        colName: item['name'],
        colPrice: item['price'],
        colQuantity: 1,
      });
    }
  }

  /// Remove an item
  static Future<void> removeFromCart(String itemName) async {
    final db = await database;
    await db.delete(tableCart, where: '$colName = ?', whereArgs: [itemName]);
  }

  /// Increase quantity
  static Future<void> increaseQuantity(String itemName) async {
    final db = await database;
    await db.rawUpdate(
      '''
      UPDATE $tableCart 
      SET $colQuantity = $colQuantity + 1 
      WHERE $colName = ?
    ''',
      [itemName],
    );
  }

  /// Decrease quantity (and remove if < 1)
  static Future<void> decreaseQuantity(String itemName) async {
    final db = await database;
    final item = await db.query(
      tableCart,
      where: '$colName = ?',
      whereArgs: [itemName],
    );

    if (item.isNotEmpty) {
      final currentQty = item.first[colQuantity] as int;
      if (currentQty > 1) {
        await db.update(
          tableCart,
          {colQuantity: currentQty - 1},
          where: '$colName = ?',
          whereArgs: [itemName],
        );
      } else {
        await removeFromCart(itemName);
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
