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
      await location(db);
    });
  }

  static Future<void> location(sql.Database database) async {
    // await database.execute("DROP TABLE IF EXISTS attendancetable");

    await database.execute("""CREATE TABLE addresstable(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        address TEXT,
        user TEXT ,
        lat  REAL,
        long REAL,
        distance TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> createTables(sql.Database database) async {
    // await database.execute("DROP TABLE IF EXISTS attendancetable");

    await database.execute("""CREATE TABLE userdetails(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    fullname TEXT,
    cookie TEXT,
    requestheader TEXT,
    image TEXT,
    email TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  )
  """);
  }

  createUser(String? fullname, String? cookie, String? requestheader,
      String? image, String? email) async {
    final db = await Databasehelper.openDatabase();

    final data = {
      'fullname': fullname,
      'cookie': cookie,
      'requestheader': requestheader,
      "image": image,
      "email": email
    };
    final id = await db.insert('userdetails', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return db.query('userdetails', orderBy: "id");
  }

  updateUser(
    int id,
    String image,
    String? email,
  ) async {
    final db = await Databasehelper.openDatabase();

    final data = {
      'image': image,

      'email': email,
      // 'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('userdetails', data, where: "id = ?", whereArgs: [id]);
    return db.query('userdetails', orderBy: "id");
  }

  createAddress(
    String? address,
    String? user,
    String? lat,
    String? long,
    String? km,
  ) async {
    final db = await Databasehelper.openDatabase();

    final data = {
      'address': address,
      "user": user,
      "lat": lat,
      "long": long,
      "distance": km
    };
    final id = await db.insert('addresstable', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return db.query('addresstable', orderBy: "id");
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

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await Databasehelper.openDatabase();
    return db.query('addresstable', orderBy: "id");
  }

  Future<void> deleteAllItems() async {
    final db = await Databasehelper.openDatabase();

    await db.delete('addresstable');
  }
}
