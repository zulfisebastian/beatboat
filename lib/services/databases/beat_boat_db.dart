import 'activity/activity_table.dart';
import 'profile/profile_table.dart';
import 'product/category_table.dart';
import 'product/product_table.dart';
import 'transaction/addon_table.dart';
import 'transaction/cart_table.dart';
import 'profile/menu_table.dart';
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
    await AddonTable().createTable(db);
  }
}
