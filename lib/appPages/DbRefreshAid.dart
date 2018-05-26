import 'package:flutter0322/globals.dart' as globals;

abstract class DbRefreshAid {
  // only do one at a time...  hackish? way to avoid missing unsubscribe.
  static void dbAidWatchForNextChange(DbRefreshAid dbThis, String tableName) {
    globals.globalDerby.derbyDb.recentChangesController.stream
        .firstWhere((tableName) => tableName == tableName)
        .then((String tableName) {
      print("dbAidWatchForNextChange: Match from stream: $tableName");
      bool widgetMounted=dbThis.queryDataFromDb();

      if(widgetMounted) {
        dbAidWatchForNextChange(dbThis, tableName);
      }
    });
  }

  bool queryDataFromDb();
}
