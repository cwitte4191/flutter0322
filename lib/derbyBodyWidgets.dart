import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/RacerApp.dart';

import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/testData.dart';
import 'package:flutter0322/widgets/RaceBracketWidget.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/widgets/RaceSelectionWidget.dart';
import 'package:flutter0322/widgets/RacerWidget.dart';
import 'package:flutter0322/globals.dart' as globals;

class DerbyBodyWidgets {
  Widget getBody() {
    new TestData().getRbd();
    return getTestDataRaceHistoryBody();
    //return getRacerListBody();
  }

  Widget getList2() {
    var textList = [];
    for (int x = 0; x < 500; x++) {
      textList.add(new Text("Text: " + x.toString()));
    }
    return new ListView(
      children: textList,
    );
  }

  Widget getBracketListBody(Map<int, RaceBracket> bracketMap) {
    var bracketWidgetList = new List<Widget>();
    int rowNum = 0;
    void add1Bracket(int key, RaceBracket raceBracket) {
      Color bg = rowNum++ % 2 == 0 ? Colors.grey : null;
      bracketWidgetList.add(new RaceBracketWidget(
        raceBracket: raceBracket,
        bgColor: bg,
      ));
    }

    bracketMap.forEach(add1Bracket);

    return new ListView(
      children: bracketWidgetList,
    );
  }





  Widget getRaceStandingHistoryBody(Map<int, RaceStanding> standingMap) {
    print("getRaceStandingHistoryBody: begin");

    List<RaceStanding> raceStandingList = [];

    void add1Widget(int key, RaceStanding raceStanding) {
      //RaceStandingUi raceStandingUi = new RaceStandingUi(raceStanding);
      raceStandingList.add(raceStanding);

    }

    standingMap.forEach(add1Widget);
    raceStandingList.sort((a, b) =>
        -1 *
        a.lastUpdateMS.compareTo(b.lastUpdateMS));



    Widget raceStandingItemBuilder(BuildContext context, int index) {
      print("raceStandingItemBuilder $index");
      RaceStandingUi raceStandingUi = new RaceStandingUi(raceStandingList[index]);
      RaceResultWidget rrw = new RaceResultWidget(
          displayableRace: raceStandingUi,
          driverMap: globals.globalDerby.racerMap);
      return rrw;
    }
    return ListView.builder(
        itemBuilder: raceStandingItemBuilder, itemCount: raceStandingList.length);
  }

  Widget getTestDataRaceHistoryBody() {
    print("getRaceHistoryBody begin (test): ");

    var raceStanding = new RaceStanding(car1: 110, car2: 111);

    RacePhase.marshallRaceEntryListFromRacePair(
        -50, raceStanding.phase1EntryList, raceStanding.racePair);
    RacePhase.marshallRaceEntryListFromRacePair(
        200, raceStanding.phase2EntryList, raceStanding.racePair);

    raceStanding.chartPosition = "Heat 23";

    var racePhaseT1 = new RacePhase();
    racePhaseT1.startMs = 232;
    racePhaseT1
        .addRaceEntry(new RaceEntry(lane: 1, carNumber: 101, resultMS: 050));
    racePhaseT1
        .addRaceEntry(new RaceEntry(lane: 2, carNumber: 102, resultMS: 0));
    racePhaseT1.phaseNumber = 1;

    var racePhaseT2 = new RacePhase();
    racePhaseT2.startMs = 232;
    racePhaseT2
        .addRaceEntry(new RaceEntry(lane: 1, carNumber: 201, resultMS: 053));
    racePhaseT2
        .addRaceEntry(new RaceEntry(lane: 2, carNumber: 202, resultMS: 0));
    racePhaseT2.phaseNumber = 2;

    var driverMap = new Map<int, Racer>();
    driverMap[101] = new Racer()..racerName = "Bugs";
    driverMap[201] = new Racer()..racerName = "Bunny";
    driverMap[202] = new Racer()..racerName = "Elmer";
    driverMap[102] = new Racer()..racerName = "Fudd";

    var rpList = new List<Widget>();
    for (int x = 0; x < 50; x++) {
      var rrw = null;
      if (x % 3 == 0) {
        rrw = new RaceResultWidget(
            displayableRace: new RacePhaseUi(racePhaseT1),
            driverMap: driverMap);
      }
      if (x % 3 == 1) {
        rrw = new RaceResultWidget(
            displayableRace: new RacePhaseUi(racePhaseT2),
            driverMap: driverMap);
      }
      if (x % 3 == 2) {
        rrw = new RaceResultWidget(
            displayableRace: new RaceStandingUi(raceStanding),
            driverMap: driverMap);
      }

      if (rrw != null) rpList.add(rrw);
    }
    //print("racePhase history: $rpList");
    print("getRaceHistoryBody done: " + rpList.length.toString());

    return new ListView(
      children: rpList,
    );
  }

  Widget getRaceSelectionBody(Map<String, String> flist) {
    var raceSelectionList = new List<Widget>();

    int x = 0;
    List<String> keys = flist.keys.toList();
    keys.sort((a, b) => a.compareTo(b) * 1);

    for (var displayFile in keys) {
      Color bg = x % 2 == 0 ? Colors.grey : null;
      x++;
      raceSelectionList.add(new RaceSelectionWidget(
        displayFile: displayFile,
        fullPath: flist[displayFile],
        bgColor: bg,
      ));
    }
    return new ListView(
      children: raceSelectionList,
    );
  }
}
