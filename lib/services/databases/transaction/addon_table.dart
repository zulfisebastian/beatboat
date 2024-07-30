import 'package:beatboat/models/product/cart_model.dart';
import 'package:beatboat/services/databases/database_services.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/product/addon_model.dart';

class AddonTable {
  final tableName = "addon";

  Future<void> createTable(db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" STRING NOT NULL,
      "addon_id" STRING NOT NULL,
      "product_id" STRING NOT NULL,
      "cart_id" STRING NOT NULL,
      "name" STRING NOT NULL,
      "price" INTEGER NOT NULL,
      "qty" INTEGER NOT NULL,
      "counter" INTEGER NOT NULL,
      PRIMARY KEY("id")
    );""");
  }

  Future<int> addAddon(AddonData data) async {
    final db = await DatabaseServices().database;
    return await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateAddon(AddonData data, CartData cart) async {
    final db = await DatabaseServices().database;
    return await db.update(
      tableName,
      data.toJson(),
      where: 'id = ? AND cart_id = ?',
      whereArgs: [data.id, cart.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteAddon(AddonData data) async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<List<AddonData>?> getAddonByCartId(String id, CartData cart) async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'addon_id = ? AND cart_id = ?',
      whereArgs: [id, cart.id],
    );

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => AddonData.fromJson(
        maps[index],
      ),
    );
  }

  Future<List<AddonData>?> getAllData() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => AddonData.fromJson(
        maps[index],
      ),
    );
  }

  Future<int> truncateAddon() async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
    );
  }
}
