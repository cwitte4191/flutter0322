import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter0322/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import 'package:event_bus/event_bus.dart' as events;

class DerbyDb {
  String dbPath;
  Database database;
  StreamController<HasRelational> fromNetworkController;
  StreamController<String> recentChangesController;
  events.EventBus clientEventBus;

  final PendingSql pendingSql;

  DerbyDb() : pendingSql = new PendingSql();

  Future init({bool doReset}) async {
    createFromNetworkStream();
    createRecentChangesStream();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    dbPath = join(documentsDirectory.path, "demo.db");
    File dbFile = new File(dbPath);
    if (!dbFile.existsSync() || doReset) {
      await deleteAndDefine();
    } else {
      print("DerbyDb reusing existing db");
      await openDb();
    }
  }

  Future flushPendingBatch() async {
    await pendingSql.doFlush(this);
  }

  void createFromNetworkStream() {
    fromNetworkController = StreamController.broadcast<HasRelational>();

    fromNetworkController.stream.forEach((model) => addNewModel(model));
  }

  void createRecentChangesStream() {
    recentChangesController = StreamController.broadcast<String>();

    print("createRecentChangesStream begin.");
    clientEventBus = new events.EventBus();
    Stream<dynamic> stream = clientEventBus.on(RacePhase);

    stream.listen((event) {
      print("Event bus handler2: gotRacePhase:  ${event}");
      return null;
    });

    clientEventBus.fire("foo");
    clientEventBus.fire(new RacePhase());
    print("createRecentChangesStream done.");
  }

  /*
  void gotRacePhase(Object event) {

    print("Event bus handler: gotRacePhase:  $event");
  }
  */

  void testBroadcastSink() {
    final String tbs = "testBroadcastSink";
    print("testBroadcastSink $tbs begin.");
    recentChangesController.stream.listen(
        (istring) => print("$tbs recentChangesSubscriber1: got $istring"));
    recentChangesController.stream.listen(
        (istring) => print("$tbs recentChangesSubscriber2: got $istring"));

    int now = new DateTime.now().millisecondsSinceEpoch;
    recentChangesController.add("$tbs testBroadcast now:  $now");

    countStream(5).pipe(recentChangesController);
    // countStream(8).pipe(recentChangesController);
  }

  Stream<String> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i.toString();
    }
  }

  Future deleteAndDefine() async {
    print("deleteAndDefine: beginning.");
    await deleteDatabase(dbPath);

    print("deleteAndDefine: opening.");

    await openDb();

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
    if (args != null && args.item1 != null) {
      //print ("derbyDb.execute from Stream: ${args.item1}");
      return database.execute(args.item1, args.item2);
    }
  }

  Batch getBatch() {
    return database.batch();
  }

  final RecentWatch recentWatch = new RecentWatch();

  Future addNewModel(HasRelational model, {bool defer: false}) async {
    if (defer) {
      await pendingSql.add(this, model);
    } else {
      await execute(model.generateSql());
      recentWatch.receivedInput(this, model.runtimeType.toString());
    }
  }

  Future openDb() async {
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
      await db.execute(RaceBracket.getCreateSql());
      print("deleteAndDefine: create complete.");
    });
  }
}

class RecentWatch {
  Duration recentDuration = new Duration(seconds: 1);
  Timer recentTimer;
  int recentTimeMS = 0;
  Set<String> recentModels = new HashSet();

  DerbyDb derbyDb;
  RecentWatch();

  void receivedInput(DerbyDb derbyDb, String modelString) {
    this.derbyDb = derbyDb;

    recentModels.add(modelString);
    recentTimeMS = DateTime.now().millisecondsSinceEpoch;

    if (recentTimer != null && recentTimer.isActive) {
      recentTimer.cancel();
    }
    recentTimer = new Timer(recentDuration, recentPublishActivity);
  }

  // recent changes is intended to cause a UI refresh/repaint
  //   don't do this for every record, just once after the refresh.
  void recentPublishActivity() {
    if (this.derbyDb == null) return;

    //TODO syncronization may be needed!
    var now = DateTime.now();
    for (String recentModel in recentModels) {
      print("recentPublishActivity: $now $recentModel");
      derbyDb.recentChangesController.add(recentModel);
    }
  }
}

class PendingSql {
  HashSet<String> pendingTypes = new HashSet();
  List<Tuple2<String, List<dynamic>>> pendingSqlList = new List();

  PendingSql();

  Future add(DerbyDb derbyDb, HasRelational model) async {
    pendingSqlList.add(model.generateSql());
    pendingTypes.add(model.runtimeType.toString());
    await potentialFlush(derbyDb);
  }

  Future potentialFlush(DerbyDb derbyDb) async {
    if (pendingSqlList.length > 200) {
      await doFlush(derbyDb);
    }
  }

  Future doFlush(DerbyDb derbyDb) async {
    if (pendingSqlList.length == 0) return;

    print ("doFlush BEGIN: ${pendingSqlList.length}");
    Batch batch = derbyDb.getBatch();
    for (Tuple2<String, List<dynamic>> x in pendingSqlList) {
      batch.execute(x.item1, x.item2);
    }
    await batch.commit(exclusive: false, noResult: true);

    for (String modelType in this.pendingTypes) {
      derbyDb.recentWatch.receivedInput(derbyDb, modelType);
    }
    pendingSqlList.clear();
    pendingTypes.clear();
    print ("doFlush COMPLETE.");

  }
}
