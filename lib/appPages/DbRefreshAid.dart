import 'package:flutter0322/globals.dart' as globals;

abstract class DbRefreshAid {
  // only do one at a time...  hackish? way to avoid missing unsubscribe.
  static void dbAidWatchForNextChange(DbRefreshAid dbThis, String wantTableName) {
    globals.globalDerby.derbyDb.recentChangesController.stream
        .firstWhere((gotTableName) => gotTableName == wantTableName)
        .then((String gotTableName) {
      print("dbAidWatchForNextChange: Match from stream: want: $wantTableName got: $gotTableName");
      bool widgetMounted=dbThis.queryDataFromDb();

      if(widgetMounted) {
        dbAidWatchForNextChange(dbThis, wantTableName);
      }
    });
  }


  bool queryDataFromDb();
}
