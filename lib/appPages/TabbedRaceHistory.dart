import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';
import 'package:flutter0322/appPages/RacePhasePage.dart';
import 'package:flutter0322/appPages/RaceStandingPage.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:flutter0322/widgets/InheritedTabState.dart';

enum HistoryType { Phase, Standing, Pending }
final Map<HistoryType, String> tabNameMap = {
  HistoryType.Phase: "Phases",
  HistoryType.Standing: "Heats",
  HistoryType.Pending: "Pending",
};
class TabbedRaceHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TabbedRaceHistoryState();
  }
}

Widget getTRH() {
  return new MyInheritedTabWidget(
       child: new TabbedRaceHistory(), initialHistoryType: HistoryType.Phase,);
}

class _TabbedRaceHistoryState extends State<TabbedRaceHistory>
    with SingleTickerProviderStateMixin {
  bool showFab = false;


  final List<Tab> myTabs = <Tab>[
    new Tab(text: tabNameMap[HistoryType.Phase]),
    new Tab(text: tabNameMap[HistoryType.Standing]),
    new Tab(text: tabNameMap[HistoryType.Pending]),
  ];
  final List<Widget> myTabViews = [
    new RacePhasePage(),
    new RaceStandingPage(historyType: HistoryType.Standing),
    new RaceStandingPage(historyType: HistoryType.Pending),
  ];
  _TabbedRaceHistoryState();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(onTabChanged);
  }

  void onTabChanged() {
    WidgetsWithFab tabWidget =
        (myTabViews[_tabController.index] as WidgetsWithFab);
    HistoryType shownType =
        (myTabViews[_tabController.index] as WidgetsWithFab).historyType;
    MyInheritedTabState istw = MyInheritedTabWidget.of(context);
    print(
        "_tabcontroller index: ${_tabController.index} type: ${shownType} tabWidget: $tabWidget istw: $istw");

    if (istw != null) {
      istw.doHistoryTypeChange(shownType);

      //istw.title = myTabs[_tabController.index].text;

/*
      setState(() {
        //syncTitleToTabName();
      });
      */

    }
  }

  /*
  void syncTitleToTabName(){
    title=myTabs[_tabController.index].text;

  }
*/
  Widget getTabFab() {
    print("getTabFab");
    try {
      Widget rc =
          (myTabViews[_tabController.index] as WidgetsWithFab).getFab(context);
      print("getTabFab: $rc");

      if (rc != null) {
        return rc;
      }
    } catch (e) {
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
    // syncTitleToTabName();

    Scaffold scaffold = new Scaffold(
      appBar: new AppBar(
        //title: new Text(title),
        title: new TextTitleWidget(),
      ),
      bottomNavigationBar: new Material(
        color: Colors.orange,
        child: new TabBar(
          tabs: myTabs,
          controller: _tabController,
        ),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new TabBarView(
        controller: _tabController,
        children: myTabViews,
      ),
      floatingActionButton: getTabFab(), // This tr
    );

    return scaffold;
  }
}


class TextTitleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TextTitleWidgetState();
  }
}

class TextTitleWidgetState extends State<TextTitleWidget> {
  @override
  Widget build(BuildContext context) {
    MyInheritedTabState istw = MyInheritedTabWidget.of(context);
    print("istw TextTitleState: $istw");
    print("istw TextTitleState: ${istw.myField}");
    if (istw != null && istw.myField!=null) {
      return (new Text(tabNameMap[istw.myField]));
    } else {
      return new Text("UnknownX");
    }
  }
}
/*

class InheritedShownTabWidget extends InheritedWidget {
  HistoryType historyType;
  String title;

  InheritedShownTabWidget({
    @required this.historyType,
    @required this.title,
    child,
  }) : super(child: child);

  static InheritedShownTabWidget of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedShownTabWidget)
        as InheritedShownTabWidget);
  }

  @override
  bool updateShouldNotify(InheritedShownTabWidget old) {
    print("istw updateShouldNotify: $title");
    //return historyType != old.historyType || title != old.title;
    return true;
  }

}
*/
