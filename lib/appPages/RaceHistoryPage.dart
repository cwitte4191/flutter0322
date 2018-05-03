import 'package:flutter/material.dart';
import '../network/GetS3Object.dart';
import '../models.dart';
import '../widgets/RaceResultWidget.dart';
import '../DerbyNavDrawer.dart';
import '../derbyBodyWidgets.dart';
import '../testData.dart';

class RaceHistoryPage extends StatelessWidget {
  final String title;
  final List<Racer> racerList;
  RaceHistoryPage({this.title="Race History", this.racerList});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new DerbyBodyWidgets().getRaceHistoryBody(),
       // body: new Text("foo"),
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
        new MaterialPageRoute(builder: (context) => new RaceHistoryPage(racerList: null)));
  }
}
