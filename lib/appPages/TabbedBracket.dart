import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/globals.dart' as globals;


class TabbedBracket extends StatelessWidget {
  int tabCount;
  final RaceBracketDetailUi raceBracketDetailUi;
  Map<String,List<DisplayableRace>> heatDetailByRound;

  TabbedBracket(this.raceBracketDetailUi) {
    heatDetailByRound = raceBracketDetailUi.getDisplayableRaceByRound();
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
              isScrollable: true,
            ),
            title: new Text(raceBracketDetailUi.raceBracketDetail.raceTitle),
          ),
          drawer: DerbyNavDrawer.getDrawer(context),

          body: new TabBarView(
            children: tabBarViews,
          ),
        ),

    );
  }
  Widget _getTabContent(List<DisplayableRace> drList){


    var rpList = new List<Widget>();
    for (var displayableRace in drList) {
      var rrw = null;
        rrw = new RaceResultWidget(
            displayableRace: displayableRace);


      if (rrw != null) rpList.add(rrw);
    }
    return RefreshIndicator(
      onRefresh: globals.globalDerby.refreshStatus.doRefresh,
    child: new ListView(
      children: rpList,
    ));
  }
}
