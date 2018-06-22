import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';
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

  bool showFab=false;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: 'Phases'),
    new Tab(text: 'Heats'),
    new Tab(text: 'Pending'),
  ];
  final List<Widget>myTabViews= [
    new RacePhasePage(),
    new RaceStandingPage(historyType:HistoryType.Standing),
    new RaceStandingPage(historyType:HistoryType.Pending),
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
      syncFab();
    });
  }

  void syncTitleToTabName(){
    title=myTabs[_tabController.index].text;

  }
  void syncFab(){

    //showFab=!showFab;
    showFab=globals.globalDerby.isLoggedIn;


  }
  Widget getTabFab(BuildContext context){
    print ("getTabFab");
    try {
      Widget rc = (myTabViews[_tabController.index] as WidgetsWithFab).getFab(context);
      print ("getTabFab: $rc");

      if (rc != null) {
        return rc;
      }
    }
    catch(e){
      print("getTabFab failed: $e");
    }
    return new Container();

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
          children: myTabViews,
      ),
      floatingActionButton: getTabFab(context), // This tr
    );

    return scaffold;

  }

  requestRefresh(BuildContext context) {}






}
