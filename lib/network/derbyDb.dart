import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter0322/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

class DerbyDb {
  String dbPath;
  Database database;
  StreamController<HasRelational> fromNetworkController;
  StreamController<String> recentChangesController;


  Future init({bool doReset}) async {
    createFromNetworkStream();
    createRecentChangesStream();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    dbPath = join(documentsDirectory.path, "demo.db");
    File dbFile = new File(dbPath);
    if (!dbFile.existsSync() || doReset) {
      await deleteAndDefine();
    }
  }

  void createFromNetworkStream() {
    fromNetworkController = StreamController.broadcast<HasRelational>();

    // this is expected to go undelivered, b/c of broadcast w/o listener rule in dart.
    fromNetworkController.add(
        new Racer(carNumber: 901, racerName: "Hardcoded"));

    fromNetworkController.stream.forEach((model) =>  addNewModel(model));
  }

  void createRecentChangesStream() {
    recentChangesController = StreamController.broadcast<String>();

  }

  void testBroadcastSink(){
    final String tbs="testBroadcastSink";
    print("testBroadcastSink $tbs begin.");
    recentChangesController.stream.listen((istring)=>print("$tbs recentChangesSubscriber1: got $istring"));
    recentChangesController.stream.listen((istring)=>print("$tbs recentChangesSubscriber2: got $istring"));

    int now=new DateTime.now().millisecondsSinceEpoch;
    Sink<String>ss=recentChangesController.sink;
    recentChangesController.add("$tbs testBroadcast now:  $now" );

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
    if (args != null && args.item1 != null) {
      //print ("derbyDb.execute from Stream: ${args.item1}");

      return database.execute(args.item1, args.item2);
    }
  }
  final RecentWatch recentWatch=new RecentWatch();

  Future addNewModel(HasRelational model) async {
    await execute(model.generateSql());
    recentWatch.receivedInput(this,model.runtimeType.toString());

  }
}
class RecentWatch{
  Duration recentDuration = new Duration(seconds:1);
  Timer recentTimer;
  int recentTimeMS=0;
  Set<String> recentModels=new HashSet();

  DerbyDb derbyDb;
  RecentWatch();


  void receivedInput(DerbyDb derbyDb,String modelString){
    this.derbyDb=derbyDb;


    recentModels.add(modelString);
    recentTimeMS=DateTime.now().millisecondsSinceEpoch;

    if(recentTimer!=null && recentTimer.isActive){
      recentTimer.cancel();
    }
    recentTimer=new Timer(recentDuration,recentPublishActivity);
  }
  // recent changes is intended to cause a UI refresh/repaint
  //   don't do this for every record, just once after the refresh.
  void recentPublishActivity() {
    if(this.derbyDb==null) return;

    //TODO syncronization may be needed!
    var now=DateTime.now();
    for(String recentModel in recentModels) {
      print("recentPublishActivity: $now $recentModel");
      derbyDb.recentChangesController.add(recentModel);
    }
  }
}
