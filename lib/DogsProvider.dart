import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'DogModel.dart';

class DogsProvider {
  DogsProvider._();

  static final DogsProvider db = DogsProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Dog ("
              "id INTEGER PRIMARY KEY,"
              "name TEXT,"
              "age INTEGER,"
              "image TEXT"
              ")");
        });
  }

  newDog(Dog newDog) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Dog");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Dog (id, name, age, image)"
            " VALUES (?, ?, ?, ?)",
        [id, newDog.name, newDog.age, newDog.image]);
    return raw;
  }

  Future<List<Dog>> getAllDogs() async {
    final db = await database;
    var res = await db.query("Dog");
    List<Dog> list =
    res.isNotEmpty ? res.map((c) => Dog.fromMap(c)).toList() : [];
    return list;
  }

  deleteDog(int id) async {
    final db = await database;
    return db.delete("Dog", where: "id = ?", whereArgs: [id]);
  }
}