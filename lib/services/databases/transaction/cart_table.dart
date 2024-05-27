import 'package:beatboat/services/databases/database_services.dart';
import 'package:sqflite/sqflite.dart';
import '../../../models/product/cart_model.dart';

class CartTable {
  final tableName = "cart";

  Future<void> createTable(db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" STRING NOT NULL,
      "category_id" STRING NOT NULL,
      "sku" STRING NOT NULL,
      "name" STRING NOT NULL,
      "description" STRING NOT NULL,
      "buy_price" INTEGER NOT NULL,
      "sell_price" INTEGER NOT NULL,
      "stock" INTEGER NOT NULL,
      "unit" STRING NOT NULL,
      "status" STRING NOT NULL,
      "order_serve" STRING NOT NULL,
      "image_url" STRING NOT NULL,
      "qty" INTEGER NOT NULL,
      PRIMARY KEY("id")
    );""");
  }

  Future<int> addCart(CartData data) async {
    final db = await DatabaseServices().database;
    return await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCart(CartData data) async {
    final db = await DatabaseServices().database;
    return await db.update(
      tableName,
      data.toJson(),
      where: 'id = ?',
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteCart(CartData data) async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<List<CartData>?> getCartById(CartData data) async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => CartData.fromJson(
        maps[index],
      ),
    );
  }

  Future<List<CartData>?> getAllCart() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => CartData.fromJson(
        maps[index],
      ),
    );
  }

  Future<int> truncateCart() async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
    );
  }
}
