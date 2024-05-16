import 'package:beatboat/services/databases/database_services.dart';
import 'package:sqflite/sqflite.dart';
import '../../../models/product/product_model.dart';

class ProductTable {
  final tableName = "product";

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
      "show" INTEGER NOT NULL,
      "unit" STRING NOT NULL,
      "status" STRING NOT NULL,
      "image_url" STRING NOT NULL,
      PRIMARY KEY("id")
    );""");
  }

  Future<int> addProduct(ProductData data) async {
    final db = await DatabaseServices().database;
    return await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addProductBatch(ProductResponse allData) async {
    if (allData.data == null) return;

    for (var data in allData.data!) {
      addProduct(data);
    }
  }

  Future<int> updateProduct(ProductData data) async {
    final db = await DatabaseServices().database;
    return await db.update(
      tableName,
      data.toJson(),
      where: 'id = ?',
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteProduct(ProductData data) async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<List<ProductData>?> getProductById(ProductData data) async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => ProductData.fromJson(
        maps[index],
      ),
    );
  }

  Future<List<ProductData>?> getAllProduct() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => ProductData.fromJson(
        maps[index],
      ),
    );
  }
}
