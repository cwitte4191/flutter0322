import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/globals.dart' as globals;

class RaceStandingPage extends StatefulWidget {
  final HistoryType historyType;
  RaceStandingPage({this.historyType});

  @override
  State<StatefulWidget> createState() {
    return new RaceStandingPageState(historyType: historyType);
  }
}

class RaceStandingPageState extends State<RaceStandingPage> {
  final HistoryType historyType;

  RaceStandingPageState({this.historyType});
  List<Map<String, dynamic>> raceStandingList = [];

  @override
  Widget build(BuildContext context) {
    Widget bodyWidgets;

    bodyWidgets = this.getRaceStandingHistoryBodyFromDB();

    return bodyWidgets;
  }

  Widget getRaceStandingHistoryBodyFromDB() {
    void repopulate(final List<Map<String, dynamic>> list2) {
      print("RaceStanding: repopulateList! $list2");

      setState(() {
        raceStandingList = list2;
      });
    }

    if (raceStandingList?.length == 0) {
      bool getPending=(historyType==HistoryType.Pending);
      // TODO: we seem to be recursing w/o this!?
      globals.globalDerby.derbyDb?.database
          ?.rawQuery(RaceStanding.getSelectSql(getPending))
          ?.then((list) => repopulate(list));
    }

    return ListView.builder(
        itemBuilder: raceStandingItemBuilder, itemCount: raceStandingList?.length);
  }

  Widget raceStandingItemBuilder(BuildContext context, int index) {
    RaceStanding raceStanding = new RaceStanding.fromSqlMap(raceStandingList[index]);

    RaceStandingUi raceStandingUi = new RaceStandingUi(raceStanding);
    RaceResultWidget rrw = new RaceResultWidget(
        displayableRace: raceStandingUi);
    return rrw;
  }
}
