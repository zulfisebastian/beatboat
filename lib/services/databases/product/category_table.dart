import 'package:beatboat/models/product/category_model.dart';
import 'package:beatboat/services/databases/database_services.dart';
import 'package:sqflite/sqflite.dart';

class CategoryTable {
  final tableName = "product_category";

  Future<void> createTable(db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" STRING NOT NULL,
      "code" STRING NOT NULL,
      "name" STRING NOT NULL,
      "image_url" STRING NOT NULL,
      PRIMARY KEY("id")
    );""");
  }

  Future<int> addCategory(CategoryData data) async {
    final db = await DatabaseServices().database;
    return await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addCategoryBatch(CategoryResponse allData) async {
    if (allData.data == null) return;

    for (var data in allData.data!) {
      addCategory(data);
    }
  }

  Future<int> updateCategory(CategoryData data) async {
    final db = await DatabaseServices().database;
    return await db.update(
      tableName,
      data.toJson(),
      where: 'id = ?',
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteCategory(CategoryData data) async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<List<CategoryData>?> getCategoryById(CategoryData data) async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => CategoryData.fromJson(
        maps[index],
      ),
    );
  }

  Future<List<CategoryData>?> getAllCategory() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => CategoryData.fromJson(
        maps[index],
      ),
    );
  }
}
