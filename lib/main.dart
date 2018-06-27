import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/BracketList.dart';
import 'package:flutter0322/appPages/RacerPage.dart';
import 'package:flutter0322/appPages/SplashPage.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';
import 'package:flutter0322/globals.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';

import 'dart:async';

import 'package:flutter0322/testData.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:flutter0322/widgets/RaceSelectionWidget.dart';
import 'package:flutter0322/widgets/TextDialogDemo.dart';

//import 'mqtt.dart';
//import 'package:pubsub/pubsub.dart';

void main() async {
  if (false) {
    runApp(new MaterialApp(home: new FocusVisibilityDemo()));

    return;
  }
  //new MqttTest().mains();
  /*
  const oneSec = const Duration(seconds:5);
  new Timer.periodic(oneSec, handleTimeout);
  */
  //runApp(new RaceHistoryApp());
  // var racerMap=new TestData().getTestRacers();
  Map<int, Racer> racerMap = new Map();
  Widget homeWidget = null;
  RaceConfig restoredRC = await RaceConfig.restoreRaceConfig();
  if (restoredRC != null) {
    globals.globalDerby = new globals.GlobalDerby(raceConfig: restoredRC);
    await globals.globalDerby.init(false);

    homeWidget = getTRH();
  }

  if (globals.globalDerby.raceConfig == null) {
    homeWidget = new SplashScreen();
  }

  runApp(new InheritedLoginWidget(
      loginCredentials: globals.globalDerby.loginCredentials,
      child: getApp(homeWidget: homeWidget)));
}

Widget getApp({Widget homeWidget}) {
  return new MaterialApp(
    title: 'Flutter Demo',
    theme: new ThemeData(
      primarySwatch: Colors.green,
    ),
    home: homeWidget,
    routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new RacerHome(),
      "/Racers": (BuildContext context) => new RacerHome(),
      "/Brackets": (BuildContext context) => new BracketList(),
      "/RacesTab": (BuildContext context) => getTRH(),
    },
  );
}

void handleTimeout(Timer t) {
  // callback function
  print("timeoutfrom main: " +
      new DateTime.now().millisecondsSinceEpoch.toString());
  //Pubsub.publish('app.component.action', 1, 2, 3, keywords: 'work also', isnt: 'this fun');
}
