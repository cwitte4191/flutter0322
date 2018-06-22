library globals;

import 'dart:async';
import 'dart:io';

import 'package:flutter0322/network/MqttOberver.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/DerbyDbCache.dart';
//import 'package:flutter0322/network/FbaseDerby.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/network/RefreshStatus.dart';
import 'package:flutter0322/network/derbyDb.dart';

class GlobalDerby {
  bool isLoggedIn = true;
  final RaceConfig raceConfig;
  //Map<int, Racer> racerMap=new Map();
  //Map<int, RaceBracket> bracketMap=new Map();

  //final FbaseDerby fbaseDerby=new FbaseDerby();
  final DerbyDb derbyDb = new DerbyDb();
  final DerbyDbCache racerCache = new DerbyDbCache<Racer>("Racer");
  final DerbyDbCache raceBracketCache =
      new DerbyDbCache<RaceBracket>("RaceBracket");
  File ndJsonPath;
  int ndJsonRefreshInProgress;
  MqttObserver mqttObserver;
  bool useMqtt=false;
  RefreshStatus refreshStatus=new RefreshStatus();

  String sqlCarNumberFilter="";

  Map<int, Racer> getRacerCache() {
    return Map.castFrom(racerCache.cacheMap);
  }

  Map<int, RaceBracket> getRaceBrakcetCache() {
    return Map.castFrom(raceBracketCache.cacheMap);
  }

  GlobalDerby({this.raceConfig}) {
    if (useMqtt && raceConfig != null) {
      mqttObserver=new MqttObserver(raceConfig.getMqttHostname());

    }
  }
  Future _cleanup() async {
    File oldNdJson = await new GetS3Object().ndJsonFile();
    if (oldNdJson != null && oldNdJson.existsSync()) {
      oldNdJson.deleteSync();
    }
  }

  Future init(bool doResetDb) async {
    //await new MqttObserver("rr1.us").init();
    if (doResetDb) {
      await _cleanup();
    }
    await derbyDb.init(doReset: doResetDb);
    await racerCache.init(derbyDb);
    await raceBracketCache.init(derbyDb);

    if(useMqtt && mqttObserver!=null) {
      mqttObserver.init();
    }

    //fbaseDerby.init();
  }
}

GlobalDerby globalDerby = new GlobalDerby();
