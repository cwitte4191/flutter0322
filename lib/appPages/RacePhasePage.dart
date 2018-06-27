import 'package:flutter/material.dart';
import 'package:flutter0322/dialogs/AddPendingCarsDialog.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';
import 'package:flutter0322/appPages/RaceStandingPage.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';
import 'package:flutter0322/globals.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/widgets/FilterRowWidget.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/globals.dart' as globals;

class RacePhasePage extends StatefulWidget implements WidgetsWithFab {
  final HistoryType historyType=HistoryType.Phase;
  @override
  State<StatefulWidget> createState() {
    return new RacePhasePageState();
  }

  @override
  Widget getFab(BuildContext context) {
    InheritedLoginWidget ilw=InheritedLoginWidget.of(context);

    if(! ilw.loginCredentials.canAddRacePhase()){
      return new Container();
    }

    return new FloatingActionButton(
      onPressed: () {
        onFabClicked(context);
      },
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  void onFabClicked(BuildContext context) {

    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AddPendingCarsDialog(
            historyType: HistoryType.Phase,
          );
        },
        fullscreenDialog: true));
  }

}

class RacePhasePageState extends State<RacePhasePage> implements DbRefreshAid {
  String title;
  List<Map<String, dynamic>> racePhaseList = [];
  bool firstTime = true;

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
    if (firstTime) {
      // TODO: we seem to be recurse ing w/o this!?
      queryDataFromDb();
      firstTime = false; // don't initiate query on subsequent build events.
    }

    int listSize = racePhaseList?.length;
    listSize += 1; // artificially larger for filter.

    return RefreshIndicator(
        onRefresh: globals.globalDerby.refreshStatus.doRefresh,
        child: ListView.builder(
            itemBuilder: racePhaseItemBuilder, itemCount: listSize));
  }

  Widget racePhaseItemBuilder(BuildContext context, int index) {
    if (index == 0) {
      return new FilterRowWidget(triggerTable: RacePhase);
    } else {
      index = index - 1;
    }
    RacePhase racePhase = new RacePhase.fromSqlMap(racePhaseList[index]);

    RacePhaseUi racePhaseUi = new RacePhaseUi(racePhase);
    RaceResultWidget rrw = new RaceResultWidget(displayableRace: racePhaseUi);
    return rrw;
  }

  @override
  bool queryDataFromDb() {
    globals.globalDerby.derbyDb?.database
        ?.rawQuery(RacePhase.getSelectSql(
            carFilter: globals.globalDerby.sqlCarNumberFilter))
        ?.then((list) {
      print("RacePhase: repopulateList! $list");

      if (this.mounted) {
        setState(() {
          racePhaseList = list;
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
