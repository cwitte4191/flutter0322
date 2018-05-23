import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/derbyBodyWidgets.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:flutter0322/widgets/RaceResultWidget.dart';

enum HistoryType{ Phase, Standing, Pending}
class RaceHistoryPage extends StatefulWidget{
  final HistoryType historyType;
  final Map<int,RaceStanding> raceStandingMap;
  final Map<int,RaceStanding> racePendingMap;

  RaceHistoryPage({this.historyType, this.raceStandingMap, this.racePendingMap});
  @override
  State<StatefulWidget> createState() {
    return new RaceHistoryPageState(historyType: this.historyType,raceStandingMap: this.raceStandingMap, racePendingMap: this.racePendingMap);
  }
}
class RaceHistoryPageState extends State<RaceHistoryPage> {
  String title;
   List<Map<String,dynamic>> racePhaseList=[];
  final Map<int,RaceStanding> raceStandingMap;
  final Map<int,RaceStanding> racePendingMap;
  final HistoryType historyType;
  RaceHistoryPageState({this.historyType,  this.raceStandingMap, this.racePendingMap});

  @override
  Widget build(BuildContext context) {
    Widget bodyWidgets;

    DerbyBodyWidgets derbyBodyWidgets=new DerbyBodyWidgets();
    if(historyType==HistoryType.Phase) {
      bodyWidgets = this.getRacePhaseHistoryBodyFromDB();
      title="Race Phase History";
    }else if (raceStandingMap!=null) {
      bodyWidgets=derbyBodyWidgets.getRaceStandingHistoryBody(raceStandingMap);
      title="Race Heat History";
    }else if (racePendingMap!=null) {
      bodyWidgets=derbyBodyWidgets.getRaceStandingHistoryBody(racePendingMap);
      title="Pending Races";
    }else {
      bodyWidgets=derbyBodyWidgets.getTestDataRaceHistoryBody();
    }

    final List<Tab> myTabs = <Tab>[
      new Tab(text: 'Phases'),
      new Tab(text: 'Heats'),

      new Tab(text: 'Pending'),
    ];


    Scaffold scaffold= new Scaffold(
      appBar: new AppBar(
        title: new Text(title),

      ),
      bottomNavigationBar:new Material(
          color: Colors.orange,
          child:new TabBar(
            tabs: myTabs,
          ),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new TabBarView(children: <Widget>[bodyWidgets,bodyWidgets,bodyWidgets]),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>          requestRefresh(context)
        ,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This tr
    );
    return new DefaultTabController(
        length: myTabs.length,
        child: scaffold);
  }
  void requestRefresh(BuildContext context) async{
    Map<int,RacePhase> racerMap=await new RefreshData().doRefresh( "RacePhase");

    print("RacePhase reload size: "+racerMap.length.toString());
    //TODO: change constructor
    /*
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new RaceHistoryPage(racePhaseMap: racerMap)));
        */
  }



  Widget getRacePhaseHistoryBodyFromDB() {
    void repopulate(final List<Map<String, dynamic>> list2 ) {
      print("RacePhase: repopulateList! $list2");

      setState(() {racePhaseList=list2; });
    }
    if(racePhaseList?.length==0) {// TODO: we seem to be recursing w/o this!?
      globals.globalDerby.derbyDb?.database?.rawQuery(RacePhase.getSelectSql())
          ?.then((list) => repopulate(list));
    }


    return ListView.builder(
        itemBuilder: racePhaseItemBuilder, itemCount: racePhaseList?.length);
  }
  Widget racePhaseItemBuilder(BuildContext context, int index) {
    RacePhase racePhase=new RacePhase.fromSqlMap(racePhaseList[index]);

    RacePhaseUi racePhaseUi = new RacePhaseUi(racePhase);
    RaceResultWidget rrw = new RaceResultWidget(
        displayableRace: racePhaseUi,
        driverMap: globals.globalDerby.racerMap);
    return rrw;
  }


}
