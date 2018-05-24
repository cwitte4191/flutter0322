import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/derbyDb.dart';


class DerbyDbCache<T extends HasRelational>{
  final String modelString;
  Map<int, HasRelational> cacheMap=new Map();

  DerbyDb derbyDb;
  DerbyDbCache(this.modelString);

  void init(DerbyDb ddb) async {
    this.derbyDb=ddb;
    ddb.recentChangesController.stream.listen(onChangeHandler);

    refreshFromDb();

  }
  void refreshRacer()async{
    var sqlRows=await derbyDb?.database?.rawQuery(Racer.getSelectSql());

    for(var row in sqlRows){
      Racer r=Racer.fromSqlMap(row);
      cacheMap[r.carNumber]=r;
    }
  }

  void refreshRaceBracket() async {
    var sqlRows=await derbyDb?.database?.rawQuery(RaceBracket.getSelectSql());

    for(var row in sqlRows){
      RaceBracket r=RaceBracket.fromSqlMap(row);
      cacheMap[r.id]=r;
    }
  }

  void onChangeHandler(String tableChanged) {
    if(tableChanged==modelString){
      print("DerbyDbCache: refreshing $modelString");
      refreshFromDb();
    }
  }

  void refreshFromDb() {
    switch(modelString){
      case "Racer":
        refreshRacer();
        break;
      case "RaceBracket":
        refreshRaceBracket();
        break;
    }
  }
}