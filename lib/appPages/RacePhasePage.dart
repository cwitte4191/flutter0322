import 'package:flutter/material.dart';
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

class RacePhasePageState extends State<RacePhasePage> {
  String title;
  List<Map<String, dynamic>> racePhaseList = [];

  @override
  Widget build(BuildContext context) {
    Widget bodyWidgets;

    bodyWidgets = this.getRacePhaseHistoryBodyFromDB();
    title = "Race Phase History";

    return bodyWidgets;
  }

  Widget getRacePhaseHistoryBodyFromDB() {
    void repopulate(final List<Map<String, dynamic>> list2) {
      print("RacePhase: repopulateList! $list2");

      setState(() {
        racePhaseList = list2;
      });
    }

    if (racePhaseList?.length == 0) {
      // TODO: we seem to be recursing w/o this!?
      globals.globalDerby.derbyDb?.database
          ?.rawQuery(RacePhase.getSelectSql())
          ?.then((list) => repopulate(list));
    }

    return ListView.builder(
        itemBuilder: racePhaseItemBuilder, itemCount: racePhaseList?.length);
  }

  Widget racePhaseItemBuilder(BuildContext context, int index) {
    RacePhase racePhase = new RacePhase.fromSqlMap(racePhaseList[index]);

    RacePhaseUi racePhaseUi = new RacePhaseUi(racePhase);
    RaceResultWidget rrw = new RaceResultWidget(
        displayableRace: racePhaseUi, driverMap: globals.globalDerby.racerMap);
    return rrw;
  }
}
