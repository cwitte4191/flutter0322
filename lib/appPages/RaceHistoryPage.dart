import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/appPages/RacePhasePage.dart';
import 'package:flutter0322/appPages/RaceStandingPage.dart';
import 'package:flutter0322/derbyBodyWidgets.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:flutter0322/widgets/RaceResultWidget.dart';

enum HistoryType{ Phase, Standing, Pending}
class RaceHistoryPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return new RaceHistoryPageState();
  }
}
class RaceHistoryPageState extends State<RaceHistoryPage> {
  String title="Update me";

  RaceHistoryPageState();

  @override
  Widget build(BuildContext context) {


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
      body: new TabBarView(children: <Widget>[new RacePhasePage(),new RaceStandingPage(historyType:HistoryType.Standing),new  RaceStandingPage(historyType:HistoryType.Pending)]),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>          requestRefresh(context)
        ,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This tr
    );
    var tabController=
     new DefaultTabController(
        length: myTabs.length,
        child: scaffold);
    //tabController.addListener();
    return tabController;
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
