import 'package:flutter0322/globals.dart' as globals;

abstract class DbRefreshAid {
  // only do one at a time...  hackish? way to avoid missing unsubscribe.
  static void dbAidWatchForNextChange(
      DbRefreshAid dbThis, String wantTableName) {
    globals.globalDerby.derbyDb.recentChangesController.stream
        .firstWhere((gotTableName) => gotTableName == wantTableName)
        .then((String gotTableName) {
      if (!dbThis.isWidgetMounted()) {
        print("dbAidWatchForNextChange: Terminating watch on unmounted widget");
      } else {
        print(
            "dbAidWatchForNextChange: Match from stream: want: $wantTableName got: $gotTableName");
        dbThis.queryDataFromDb();
        dbAidWatchForNextChange(dbThis, wantTableName);
      }
    });
  }

  bool isWidgetMounted();
  bool queryDataFromDb();
}
