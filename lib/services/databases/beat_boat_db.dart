import 'package:beatboat/services/databases/activity/activity_table.dart';
import 'package:beatboat/services/databases/profile/menu_table.dart';

import 'profile/profile_table.dart';
import 'product/category_table.dart';
import 'product/product_table.dart';
import 'transaction/cart_table.dart';
import 'package:sqflite/sqlite_api.dart';

class BeatBoatDB {
  Future<void> createTables(Database db) async {
    //Category
    await CategoryTable().createTable(db);
    await ProductTable().createTable(db);
    await CartTable().createTable(db);
    await ProfileTable().createTable(db);
    await MenuTable().createTable(db);
    await ActivityTable().createTable(db);
  }
}
