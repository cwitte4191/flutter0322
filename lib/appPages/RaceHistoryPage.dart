import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/derbyBodyWidgets.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';


class RaceHistoryPage extends StatelessWidget {
  String title;
  final Map<int,RacePhase> racePhaseMap;
  final Map<int,RaceStanding> raceStandingMap;
  RaceHistoryPage({this.title="TEST History", this.racePhaseMap, this.raceStandingMap});

  @override
  Widget build(BuildContext context) {
    Widget bodyWidgets;

    DerbyBodyWidgets derbyBodyWidgets=new DerbyBodyWidgets();
    if(racePhaseMap!=null) {
      bodyWidgets = derbyBodyWidgets.getRacePhaseHistoryBody(racePhaseMap);
      title="Race Phase History";
    }else if (raceStandingMap!=null) {
      bodyWidgets=derbyBodyWidgets.getRaceStandingHistoryBody(raceStandingMap);
      title="Race Heat History";

    }else {
      bodyWidgets=derbyBodyWidgets.getTestDataRaceHistoryBody();
    }


    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: bodyWidgets,
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>          requestRefresh(context)
        ,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
}
