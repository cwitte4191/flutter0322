import 'package:flutter/material.dart';
import '../network/GetS3Object.dart';
import '../models.dart';
import '../widgets/RaceResultWidget.dart';
import '../DerbyNavDrawer.dart';
import '../derbyBodyWidgets.dart';
import '../testData.dart';
import 'dart:async';
import 'dart:math';
class RacerHome extends StatelessWidget {
  final String title;
  BuildContext lastContext;
  final Map<int,Racer> racerMap;
  RacerHome({this.title="Racers", this.racerMap}){
    const oneSec = const Duration(seconds:5);
    //new Timer.periodic(oneSec, handleTimeout);
  }

  @override
  Widget build(BuildContext context) {
    lastContext=context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new DerbyBodyWidgets().getRacerListBody(racerMap),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>

          requestRefresh(context)
        ,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void requestRefresh(BuildContext context) async{
    Map<int,Racer> racerMap=await new RefreshData().doRefresh( "Racer");
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new RacerHome(racerMap: racerMap)));
  }
  void handleTimeout(Timer t) {
    // callback function
    print("timeoutfrom main: " + new DateTime.now().millisecondsSinceEpoch.toString());
    //Pubsub.publish('app.component.action', 1, 2, 3, keywords: 'work also', isnt: 'this fun');

    int carNumber=new Random().nextInt(999);

    racerMap[carNumber]=new Racer()..carNumber=carNumber..racerName="SeventySeven";
    Navigator.push(lastContext,
        new MaterialPageRoute(builder: (context) => new RacerHome(racerMap: racerMap)));
  }
}
