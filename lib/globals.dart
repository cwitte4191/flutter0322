library globals;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter0322/network/MqttOberver.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/DerbyDbCache.dart';
//import 'package:flutter0322/network/FbaseDerby.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/network/RefreshStatus.dart';
import 'package:flutter0322/network/derbyDb.dart';

class GlobalDerby {
  bool isLoggedIn = false;
  LoginCredentials loginCredentials=new LoginCredentials(loginRole: LoginRole.None);
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

  }
  setLoginCredentials(LoginCredentials loginCredentials){
    this.loginCredentials=loginCredentials;

    isLoggedIn=(loginCredentials!=null);

  }
}
enum LoginRole{ None, Timer, Starter, Admin}

class LoginCredentials {

  final LoginRole loginRole;
  final String sessionId;
  LoginCredentials({this.loginRole:LoginRole.None, this.sessionId});

  //TODO: we can apparently use built_value for equals check..
  //https://github.com/google/built_value.dart
  bool operator ==(o) => o is LoginCredentials && o.loginRole == loginRole && o.sessionId == sessionId;

  bool canAddRacePhase(){
    return (this.loginRole==LoginRole.Starter || this.loginRole==LoginRole.Admin|| this.loginRole==LoginRole.Timer);
  }

  bool canAddPendingRace() {
    return ( this.loginRole==LoginRole.Admin|| this.loginRole==LoginRole.Timer);
  }


  bool canChangeBracketName() {
    return ( this.loginRole==LoginRole.Admin|| this.loginRole==LoginRole.Timer);

  }
}
class InheritedLoginWidget extends InheritedWidget {
   LoginCredentials loginCredentials;

  InheritedLoginWidget({this.loginCredentials, child}): super(child:child);

  static InheritedLoginWidget of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedLoginWidget) as InheritedLoginWidget);
  }

  @override
  bool updateShouldNotify(InheritedLoginWidget old) =>
      loginCredentials != old.loginCredentials ;
}
GlobalDerby globalDerby = new GlobalDerby();
