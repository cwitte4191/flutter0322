import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/RaceResultWidget.dart';
import 'widgets/RacerWidget.dart';
import 'widgets/RaceSelectionWidget.dart';
import 'DerbyNavDrawer.dart';
import 'testData.dart';

class DerbyBodyWidgets {
  Widget getBody() {
    new TestData().getRbd();
    return getRaceHistoryBody();
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

  Widget getRacerListBody(List<Racer> racers) {
    var racerWidgetList = new List<Widget>();

    for (var x = 0; x < racers.length; x++) {
      var racer = racers[x];
      Color bg = x % 2 == 0 ? Colors.grey : null;
      racerWidgetList.add(new RacerWidget(
        racer: racer,
        bgColor: bg,
      ));
    }

    return new ListView(
      children: racerWidgetList,
    );
  }

  Widget getRaceHistoryBody() {
    var raceStanding = new RaceStanding(car1: 110, car2: 111);

    raceStanding.phase2DeleaMS = 200;
    raceStanding.phase1DeltaMS = -50;
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

    var driverMap = new Map<int, String>();
    driverMap[101] = "Bugs";
    driverMap[201] = "Bunny";
    driverMap[202] = "Elmer";
    driverMap[102] = "Fudd";

    var rpList = new List<Widget>();
    for (int x = 0; x < 50; x++) {
      var rrw = null;
      if (x % 3 == 0) {
        rrw = new RaceResultWidget(
            displayableRace: racePhaseT1, driverMap: driverMap);
      }
      if (x % 3 == 1) {
        rrw = new RaceResultWidget(
            displayableRace: racePhaseT2, driverMap: driverMap);
      }
      if (x % 3 == 2) {
        rrw = new RaceResultWidget(
            displayableRace: raceStanding, driverMap: driverMap);
      }

      if (rrw != null) rpList.add(rrw);
    }
    return new ListView(
      children: rpList,
    );
  }

  Widget getRaceSelectionBody(Map<String, String> flist) {
    var raceSelectionList = new List<Widget>();

    int x = 0;
    List<String> keys=flist.keys.toList();
    keys.sort((a, b) => a.compareTo(b) * -1);

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
