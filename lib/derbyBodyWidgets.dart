import 'package:flutter/material.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/testData.dart';
import 'package:flutter0322/widgets/RaceBracketWidget.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/widgets/RaceSelectionWidget.dart';
import 'package:flutter0322/globals.dart' as globals;

class DerbyBodyWidgets {


  Widget getList2() {
    var textList = [];
    for (int x = 0; x < 500; x++) {
      textList.add(new Text("Text: " + x.toString()));
    }
    return new ListView(
      children: textList,
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
    raceStandingList
        .sort((a, b) => -1 * a.lastUpdateMS.compareTo(b.lastUpdateMS));

    Widget raceStandingItemBuilder(BuildContext context, int index) {
      print("raceStandingItemBuilder $index");
      RaceStandingUi raceStandingUi =
          new RaceStandingUi(raceStandingList[index]);
      RaceResultWidget rrw = new RaceResultWidget(
        displayableRace: raceStandingUi,
      );
      return rrw;
    }

    return ListView.builder(
        itemBuilder: raceStandingItemBuilder,
        itemCount: raceStandingList.length);
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
