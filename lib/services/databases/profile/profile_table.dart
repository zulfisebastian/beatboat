import 'package:beatboat/services/databases/database_services.dart';
import 'package:sqflite/sqflite.dart';
import '../../../models/auth/profile_model.dart';

class ProfileTable {
  final tableName = "profile";

  Future<void> createTable(db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id" STRING NOT NULL,
      "full_name" STRING NOT NULL,
      "username" STRING NOT NULL,
      "email" STRING NOT NULL,
      "role" STRING NOT NULL,
      "status" STRING NOT NULL,
      "is_listen_printer" INTEGER NOT NULL,
      PRIMARY KEY("id")
    );""");
  }

  Future<int> addProfile(ProfileData data) async {
    final db = await DatabaseServices().database;
    return await db.insert(
      tableName,
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateProfile(ProfileData data) async {
    final db = await DatabaseServices().database;
    return await db.update(
      tableName,
      data.toJson(),
      where: 'id = ?',
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteProfile(ProfileData data) async {
    final db = await DatabaseServices().database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<ProfileData?> getProfile() async {
    final db = await DatabaseServices().database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
    );

    if (maps.isEmpty) return null;

    return ProfileData.fromJson(
      maps[0],
    );
  }
}
