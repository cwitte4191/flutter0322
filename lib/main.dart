import 'package:flutter/material.dart';
import 'appPages/RaceHistoryApp.dart';
import 'dart:async';
//import 'package:pubsub/pubsub.dart';

void main() {
  const oneSec = const Duration(seconds:5);
  new Timer.periodic(oneSec, handleTimeout);
      runApp(new RaceHistoryApp());
}
void handleTimeout(Timer t) {
  // callback function
  print("timeoutfrom main: " + new DateTime.now().millisecondsSinceEpoch.toString());
  //Pubsub.publish('app.component.action', 1, 2, 3, keywords: 'work also', isnt: 'this fun');

}

