import 'package:flutter/material.dart';
import '../DerbyNavDrawer.dart';
import '../widgets/RaceResultWidget.dart';
import '../models.dart';

class TabbedBracket extends StatelessWidget {
  int tabCount;
  final RaceBracketDetail raceBracketDetail;
  Map<String,List<DisplayableRace>> heatDetailByRound;

  TabbedBracket(this.raceBracketDetail) {
    heatDetailByRound = raceBracketDetail.getDisplayableRaceByRound();
    print("tab demo:" + heatDetailByRound.toString());
    tabCount = heatDetailByRound.keys.length;
  }
  @override
  Widget build(BuildContext context) {
    var tabBarWidgets = new List<Widget>();
    var tabBarViews = new List<Widget>();
    for (var hd in heatDetailByRound.keys) {
      tabBarWidgets.add(new Tab(text: hd));

      tabBarViews.add(_getTabContent(heatDetailByRound[hd]));
    }
    return
       new DefaultTabController(
        length: tabCount,
        child: new Scaffold(
          appBar: new AppBar(
            bottom: new TabBar(
              tabs: tabBarWidgets,
            ),
            title: new Text(raceBracketDetail.raceTitle),
          ),
          drawer: DerbyNavDrawer.getDrawer(context),

          body: new TabBarView(
            children: tabBarViews,
          ),
        ),

    );
  }
  Widget _getTabContent(List<DisplayableRace> drList){
    var driverMap = new Map<int, String>();

    var rpList = new List<Widget>();
    for (var displayableRace in drList) {
      var rrw = null;
        rrw = new RaceResultWidget(
            displayableRace: displayableRace, driverMap: driverMap);


      if (rrw != null) rpList.add(rrw);
    }
    return new ListView(
      children: rpList,
    );
  }
}
