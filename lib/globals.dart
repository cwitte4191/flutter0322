library globals;

import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';

class GlobalDerby {
  bool isLoggedIn = false;
  final RaceConfig raceConfig;
  Map<int, Racer> racerMap=new Map();
  Map<int, RaceBracket> bracketMap=new Map();
  RefreshData rdGlobal; //test refresh premature death. gc issue?

  String ndJsonPath;
  int ndJsonRefreshInProgress;

  GlobalDerby({this.raceConfig});
}

GlobalDerby globalDerby=new GlobalDerby();