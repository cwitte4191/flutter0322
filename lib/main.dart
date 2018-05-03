import 'package:flutter/material.dart';
import 'appPages/RacerApp.dart';
import 'testData.dart';
import 'widgets/RaceSelectionWidget.dart';
import 'network/GetS3Object.dart';
import 'appPages/RaceHistoryPage.dart';
import 'dart:async';
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
  var racerMap=new TestData().getTestRacers();

  runApp( new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new RacerHome(racerMap: racerMap),
    ));
  }

void handleTimeout(Timer t) {
  // callback function
  print("timeoutfrom main: " + new DateTime.now().millisecondsSinceEpoch.toString());
  //Pubsub.publish('app.component.action', 1, 2, 3, keywords: 'work also', isnt: 'this fun');

}

