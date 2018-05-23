import 'dart:async';
import 'dart:io';

import 'package:flutter0322/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

class DerbyDb {
  String dbPath;
  Database database;
  Future init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    dbPath = join(documentsDirectory.path, "demo.db");
    File dbFile = new File(dbPath);
    if (!dbFile.existsSync()) {
      await deleteAndDefine();
    }
    await demo();
  }

  Future demo() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");

// Delete the database
    await deleteDatabase(path);

// open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          "CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
    });

// Insert some records in a transaction
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print("inserted1: $id1");
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ["another name", 12345678, 3.1416]);
      print("inserted2: $id2");
    });

// Update some record
    int count = await database.rawUpdate(
        'UPDATE Test SET name = ?, VALUE = ? WHERE name = ?',
        ["updated name", "9876", "some name"]);
    print("updated: $count");

// Get the records
    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    List<Map> expectedList = [
      {"name": "updated name", "id": 1, "value": 9876, "num": 456.789},
      {"name": "another name", "id": 2, "value": 12345678, "num": 3.1416}
    ];
    print(list);
    print(expectedList);
    //assert(const DeepCollectionEquality().equals(list, expectedList));

// Count the records
    count = Sqflite
        .firstIntValue(await database.rawQuery("SELECT COUNT(*) FROM Test"));
    assert(count == 2);

// Delete a record
    count = await database
        .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
    assert(count == 1);

// Close the database
    await database.close();
  }

  Future deleteAndDefine() async {
    print("deleteAndDefine: beginning.");
    await deleteDatabase(dbPath);

    print("deleteAndDefine: opening.");

    // open the database
    database =
        await openDatabase(dbPath, version: 2, onOpen: (Database db) async {
      print("deleteAndDefine: onOpen Beginning.");
    }, onCreate: (Database db, int version) async {
      print("deleteAndDefine: onCreate Beginning.");

      // When creating the db, create the table
      await db.execute(
          //    "CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
          "CREATE TABLE Derby (id INTEGER PRIMARY KEY, datatype TEXT, json TEXT)");
      await db.execute(Racer.getCreateSql());
      await db.execute(RacePhase.getCreateSql());
      await db.execute(RaceStanding.getCreateSql());
      print("deleteAndDefine: create complete.");
    });

    ;
    print("deleteAndDefine: inserting");

    // Insert some records in a transaction
    await database.transaction((txn) async {
      // int id1 = await txn.rawInsert(
      //   'INSERT INTO Derby(id, datatype, json) VALUES(-1, "Foobar", "{}"');
      //print("inserted1: $id1");
      int id2 = await txn.rawInsert(
          'INSERT INTO Derby(id, dataType, json) VALUES(?, ?, ?)',
          [-2, "another name", "['foo']"]);
      print("inserted2e: $id2");
    });
    List<Map> list = await database.rawQuery('SELECT * FROM Derby;');
    print("select done: $list");
  }

  Future execute(Tuple2<String, List<dynamic>> args) async {
    if (args!=null && args.item1 != null) {
      return database.execute(args.item1, args.item2);
    }
  }
}
