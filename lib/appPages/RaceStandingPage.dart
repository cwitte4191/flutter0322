import 'package:flutter/material.dart';
import 'package:flutter0322/dialogs/AddPendingCarsDialog.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';
import 'package:flutter0322/globals.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/widgets/FilterRowWidget.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:observable/observable.dart';

class RaceStandingPage extends StatefulWidget implements WidgetsWithFab {
  final HistoryType historyType;
  RaceStandingPage({this.historyType});

  @override
  State<StatefulWidget> createState() {
    return new RaceStandingPageState(historyType: historyType);
  }
  @override
  Widget getFab(BuildContext context) {
    InheritedLoginWidget ilw=InheritedLoginWidget.of(context);

    print ("getFab role: ${ilw.loginCredentials.loginRole}");

    if(! ilw.loginCredentials.canAddPendingRace()){
      print ("getFab role: early bailout/return");

      return new Container();
    }

    print ("getFab role: show fab");

    if(this.historyType==HistoryType.Standing){
      return new Container(); // no fab for race standing!
    }
    return new FloatingActionButton(
      onPressed: ()  {
        onFabClicked(context);
      },

      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }
  void onFabClicked(BuildContext context) {

    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AddPendingCarsDialog(historyType: historyType,);
        },
        fullscreenDialog: true));
  }


}

class RaceStandingPageState extends State<RaceStandingPage>
    implements DbRefreshAid {
  final HistoryType historyType;
  bool firstTime = true;

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
    if (firstTime) {
      // TODO: we seem to be recurse ing w/o this!?
      queryDataFromDb();
      firstTime = false; // don't initiate query on subsequent build events.
    }

    int listSize = raceStandingList?.length;
    listSize += 1; // artificially larger for filter.

    return RefreshIndicator(
        onRefresh: globals.globalDerby.refreshStatus.doRefresh,
        child: ListView.builder(
            itemBuilder: raceStandingItemBuilder, itemCount: listSize));
  }

  Widget raceStandingItemBuilder(BuildContext context, int index) {
    if (index == 0) {
      return new FilterRowWidget(triggerTable: RaceStanding);
    } else {
      index = index - 1;
    }

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
        ?.rawQuery(RaceStanding.getSelectSql(
            getPending: getPending,
              carFilter: globals.globalDerby.sqlCarNumberFilter))
        ?.then((list) {
      print("RaceStanding: repopulateList! $list");

      if (this.mounted) {
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



