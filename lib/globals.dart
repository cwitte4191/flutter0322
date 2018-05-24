library globals;

import 'dart:async';
import 'dart:io';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/DerbyDbCache.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/network/derbyDb.dart';



class GlobalDerby {
  bool isLoggedIn = false;
  final RaceConfig raceConfig;
  //Map<int, Racer> racerMap=new Map();
  //Map<int, RaceBracket> bracketMap=new Map();

  final DerbyDb derbyDb=new DerbyDb();
  final DerbyDbCache racerCache=new DerbyDbCache<Racer>("Racer");
  final DerbyDbCache raceBracketCache=new DerbyDbCache<RaceBracket>("RaceBracket");
  File ndJsonPath;
  int ndJsonRefreshInProgress;

  Map<int,Racer>getRacerCache(){
    return Map.castFrom(racerCache.cacheMap);
  }
  Map<int,RaceBracket>getRaceBrakcetCache(){
    return Map.castFrom(raceBracketCache.cacheMap);
  }

  GlobalDerby({this.raceConfig}){

  }
  Future _cleanup()async{
    File oldNdJson=await new GetS3Object().ndJsonFile();
    if(oldNdJson!=null && oldNdJson.existsSync()){
      oldNdJson.deleteSync();
    }
  }
  Future init(bool doResetDb)async{
    //await new MqttObserver("rr1.us").init();
    if(doResetDb) {
      await _cleanup();
    }
    await derbyDb.init(doReset:doResetDb);
    await racerCache.init(derbyDb);
    await raceBracketCache.init(derbyDb);
  }
}

GlobalDerby globalDerby= new GlobalDerby();
