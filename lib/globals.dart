library globals;

import 'dart:io';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';

class GlobalDerby {
  bool isLoggedIn = false;
  final RaceConfig raceConfig;
  Map<int, Racer> racerMap=new Map();
  Map<int, RaceBracket> bracketMap=new Map();
  RefreshData rdGlobal; //test refresh premature death. gc issue?

  File ndJsonPath;
  int ndJsonRefreshInProgress;


  GlobalDerby({this.raceConfig});
  cleanup()async{
    File oldNdJson=await new GetS3Object().ndJsonFile();
    if(oldNdJson!=null){
      oldNdJson.deleteSync();
    }
  }
}

GlobalDerby globalDerby=new GlobalDerby();
