import 'package:sqflite/sqflite.dart' as sql;
import 'package:get/get.dart';

class Databasehelper extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initializeDatabase();
  }

  static Future<sql.Database> openDatabase() async {
    final databasePath = await sql.getDatabasesPath();
    final path = '$databasePath/attendance.db';
    return sql.openDatabase(path, version: 1, onCreate: (db, version) async {
      await createTables(db);
    });
  }

  static Future<void> createTables(sql.Database database) async {
    // await database.execute("DROP TABLE IF EXISTS attendancetable");

    await database.execute("""CREATE TABLE attendancetable(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user TEXT,
        checkin TEXT,
        checkout TEXT,
        location TEXT,
        batter_percentage TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  createItem(String? user, String? checkin, String? checkout, String? location,
      String? batterpercentage) async {
    final db = await Databasehelper.openDatabase();

    final data = {
      'user': user,
      'checkin': checkin,
      'checkout': checkout,
      "location": location,
      "batter_percentage": batterpercentage
    };
    final id = await db.insert('attendancetable', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return db.query('attendancetable', orderBy: "id");
  }

  updateItem(int id, String batterpercentage, String? descrption,
      String? checkout) async {
    final db = await Databasehelper.openDatabase();

    final data = {
      'location': descrption,
      "batter_percentage": batterpercentage,
      'checkout': checkout,
      // 'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('attendancetable', data, where: "id = ?", whereArgs: [id]);
    return db.query('attendancetable', orderBy: "id");
  }

  static Future<void> initializeDatabase() async {
    final database = await openDatabase();

    print(database);
    // Check if the database is null before initializing
    if (database == null) {
      print('Database path: ${database.path}');

      await createTables(database);
    } else {
      // await database.execute("DROP TABLE IF EXISTS attendancetable");

      print('Error opening the database.');
    }
  }
}
