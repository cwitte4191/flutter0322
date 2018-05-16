import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/RacerApp.dart';
import 'package:flutter0322/models.dart';

import 'dart:async';

import 'package:flutter0322/testData.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:flutter0322/widgets/RaceSelectionWidget.dart';

//import 'mqtt.dart';
//import 'package:pubsub/pubsub.dart';

void main() {
  //new GetS3Object().writeCounter(77);
  //new GetS3Object().getS3ObjectAsFile("foo");

  //new MqttTest().mains();
  /*
  const oneSec = const Duration(seconds:5);
  new Timer.periodic(oneSec, handleTimeout);
  */
      //runApp(new RaceHistoryApp());
 // var racerMap=new TestData().getTestRacers();
  Map<int,Racer> racerMap=new Map();
  Widget homeWidget=null;
  if(globals.globalDerby.raceConfig==null){
    homeWidget=null;

  }


  runApp( new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: //RaceSelectionWidget.getLoadingDialog()
     new RacerHome(racerMap: racerMap),
    ));
  }

void handleTimeout(Timer t) {
  // callback function
  print("timeoutfrom main: " + new DateTime.now().millisecondsSinceEpoch.toString());
  //Pubsub.publish('app.component.action', 1, 2, 3, keywords: 'work also', isnt: 'this fun');

}

