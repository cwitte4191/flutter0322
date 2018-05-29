import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';
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

class RaceStandingPageState extends State<RaceStandingPage>
    implements DbRefreshAid {
  final HistoryType historyType;
  bool firstTime=true;

  RaceStandingPageState({this.historyType}) {
    DbRefreshAid.dbAidWatchForNextChange(this, "RaceStanding");
  }
  List<Map<String, dynamic>> raceStandingList = [];

  @override
  Widget build(BuildContext context) {
    Widget bodyWidgets;

    bodyWidgets = this.getRaceStandingHistoryBodyFromDB();

    return bodyWidgets;
  }

  Widget getRaceStandingHistoryBodyFromDB() {

    if(firstTime){
      // TODO: we seem to be recurse ing w/o this!?
      queryDataFromDb();
      firstTime=false; // don't initiate query on subsequent build events.
    }

    return ListView.builder(
        itemBuilder: raceStandingItemBuilder,
        itemCount: raceStandingList?.length);
  }

  Widget raceStandingItemBuilder(BuildContext context, int index) {
    RaceStanding raceStanding =
        new RaceStanding.fromSqlMap(raceStandingList[index]);

    RaceStandingUi raceStandingUi = new RaceStandingUi(raceStanding);
    RaceResultWidget rrw =
        new RaceResultWidget(displayableRace: raceStandingUi);
    return rrw;
  }

  @override
  bool queryDataFromDb() {
    bool getPending = (historyType == HistoryType.Pending);
    globals.globalDerby.derbyDb?.database
        ?.rawQuery(RaceStanding.getSelectSql(getPending))
        ?.then((list) {
      print("RaceStanding: repopulateList! $list");

      if(this.mounted) {
        setState(() {
          raceStandingList = list;
        });
      }
    });
    return this.mounted;
  }

  @override
  bool isWidgetMounted() {
    return this.mounted;
  }

}
