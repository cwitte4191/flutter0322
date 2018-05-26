import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/globals.dart' as globals;

class RacePhasePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RacePhasePageState();
  }
}

class RacePhasePageState extends State<RacePhasePage> implements DbRefreshAid {
  String title;
  List<Map<String, dynamic>> racePhaseList = [];

  RacePhasePageState() {
    DbRefreshAid.dbAidWatchForNextChange(this, "RacePhase");
  }
  @override
  Widget build(BuildContext context) {
    Widget bodyWidgets;

    bodyWidgets = this.getRacePhaseHistoryBodyFromDB();
    title = "Race Phase History";

    return bodyWidgets;
  }

  Widget getRacePhaseHistoryBodyFromDB() {


    if (racePhaseList?.length == 0) {
      // TODO: we seem to be recursing w/o this!?
      queryDataFromDb();
    }

    return ListView.builder(
        itemBuilder: racePhaseItemBuilder, itemCount: racePhaseList?.length);
  }

  Widget racePhaseItemBuilder(BuildContext context, int index) {

    RacePhase racePhase = new RacePhase.fromSqlMap(racePhaseList[index]);

    RacePhaseUi racePhaseUi = new RacePhaseUi(racePhase);
    RaceResultWidget rrw = new RaceResultWidget(
        displayableRace: racePhaseUi);
    return rrw;
  }
  @override
  bool queryDataFromDb() {
    globals.globalDerby.derbyDb?.database
        ?.rawQuery(RacePhase.getSelectSql())
        ?.then((list) {
      print("RacePhase: repopulateList! $list");

      if(this.mounted) {
        setState(() {
          racePhaseList = list;
        });
      }
    });
    return this.mounted;

  }
}
