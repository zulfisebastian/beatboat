import 'package:beatboat/services/databases/database_services.dart';
import 'package:sqflite/sqflite.dart';
import '../../../models/activity/activity_model.dart';

class ActivityTable {
  final tableName = "activity";

  Future<void> createTable(db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "activity" STRING NOT NULL,
      "number" STRING NOT NULL,
      "bill_type" STRING,
      "customer_name" STRING NOT NULL,
      "nfc_uid" STRING NOT NULL,
      "amount" INTEGER NOT NULL,
      "last_update" STRING NOT NULL,
      "pic" STRING NOT NULL,
      PRIMARY KEY("number")
    );""");
  }

  Future<int> addActivity(ActivityData data) async {
    final db = await DatabaseServices().database;
    return await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addActivityBatch(ActivityResponse allData) async {
    if (allData.data == null) return;

    for (var data in allData.data!) {
      addActivity(data);
    }
  }

  Future<int> deleteActivity(ActivityData data) async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
      where: 'number = ?',
      whereArgs: [data.number],
    );
  }

  Future<List<ActivityData>?> getActivityByNumber(ActivityData data) async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'number = ?',
      whereArgs: [data.number],
    );

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => ActivityData.fromJson(
        maps[index],
      ),
    );
  }

  Future<List<ActivityData>?> getAllActivity() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) return null;

    return List.generate(
      maps.length,
      (index) => ActivityData.fromJson(
        maps[index],
      ),
    );
  }
}
