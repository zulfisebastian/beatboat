import 'package:beatboat/services/databases/beat_boat_db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseServices {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = "beatboat.db";
    final path = await getDatabasesPath();
    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> _create(Database database, int version) async =>
      await BeatBoatDB().createTables(database);

  Future<void> _update(Database database, int version) async {
    await BeatBoatDB().createTables(database);
  }

  Future<void> deleteDatabase() async {
    final path = await fullPath;
    return databaseFactory.deleteDatabase(path);
  }
}
