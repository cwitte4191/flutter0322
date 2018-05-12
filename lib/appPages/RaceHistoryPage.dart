import 'package:flutter/material.dart';
import '../network/GetS3Object.dart';
import '../models.dart';
import '../widgets/RaceResultWidget.dart';
import '../DerbyNavDrawer.dart';
import '../derbyBodyWidgets.dart';
import '../testData.dart';

class RaceHistoryPage extends StatelessWidget {
  final String title;
  final Map<int,RacePhase> raceMap;
  RaceHistoryPage({this.title="Race History", this.raceMap});

  @override
  Widget build(BuildContext context) {
    print("RaceHistoryPage build: $raceMap");
    Widget bodyWidgets;
    if(raceMap==null){
      bodyWidgets=new DerbyBodyWidgets().getTestDataRaceHistoryBody();
    }
    else{
      bodyWidgets=new DerbyBodyWidgets().getRaceHistoryBody(raceMap);
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
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new RaceHistoryPage(raceMap: racerMap)));
  }
}
