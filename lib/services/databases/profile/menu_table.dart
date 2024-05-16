import 'package:beatboat/services/databases/database_services.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/auth/menu_model.dart';

class MenuTable {
  final tableName = "menu";

  Future<void> createTable(db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "menu_slug" STRING NOT NULL,
      "menu_name" STRING NOT NULL,
      PRIMARY KEY("menu_slug")
    );""");
  }

  Future<int> addMenu(MenuData data) async {
    final db = await DatabaseServices().database;
    return await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addMenuBatch(List<MenuData>? allData) async {
    if (allData == null) return;
    for (var data in allData) {
      addMenu(data);
    }
  }

  Future<int> truncateMenu() async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
    );
  }

  Future<MenuData?> getMenu() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
    );

    if (maps.isEmpty) return null;

    return MenuData.fromJson(
      maps[0],
    );
  }

  Future<List<MenuData>?> getAllMenu() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => MenuData.fromJson(
        maps[index],
      ),
    );
  }
}
