import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/appPages/RacePhasePage.dart';
import 'package:flutter0322/appPages/RaceStandingPage.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/globals.dart' as globals;

enum HistoryType{ Phase, Standing, Pending}
class TabbedRaceHistory extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    return new _TabbedRaceHistoryState();
  }
}
class _TabbedRaceHistoryState extends State<TabbedRaceHistory> with SingleTickerProviderStateMixin{
  String title="Update me";


  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Phases'),
    new Tab(text: 'Heats'),
    new Tab(text: 'Pending'),
  ];
  _TabbedRaceHistoryState();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(onTabChanged);
  }
  void onTabChanged(){
    print( "_tabcontroller index: ${_tabController.index}");
    setState(() {
      syncTitleToTabName();
    });
  }

  void syncTitleToTabName(){
    title=myTabs[_tabController.index].text;

  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {




    syncTitleToTabName();

    Scaffold scaffold= new Scaffold(
      appBar: new AppBar(
        title: new Text(title),

      ),
      bottomNavigationBar:new Material(
          color: Colors.orange,
          child:new TabBar(
            tabs: myTabs,
            controller: _tabController,

          ),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new TabBarView(
          controller: _tabController,
          children: <Widget>[new RacePhasePage(),new RaceStandingPage(historyType:HistoryType.Standing),new  RaceStandingPage(historyType:HistoryType.Pending)]
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>          requestRefresh(context)
        ,
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ), // This tr
    );

    return scaffold;

  }
  void requestRefresh(BuildContext context) async{
    await globals.globalDerby.refreshStatus.doRefresh();

/*
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new TabbedRaceHistory()));
            */

  }





}
