import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/derbyBodyWidgets.dart';
import 'package:flutter0322/globals.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/widgets/RaceBracketWidget.dart';
import 'package:flutter0322/globals.dart' as globals;

class BracketList extends StatelessWidget {
  final String title;
  BuildContext lastContext;
  BracketList({this.title = "Brackets"}) {}

  @override
  Widget build(BuildContext context) {
    lastContext = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: getBracketListBody(),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Widget getBracketListBody() {
    var bracketWidgetList = new List<Widget>();
    int rowNum = 0;
    void add1Bracket(int key, RaceBracket raceBracket) {
      Color bg = rowNum++ % 2 == 0 ? Colors.grey : null;
      bracketWidgetList.add(

          new RaceBracketWidget(
        raceBracket: raceBracket,
        bgColor: bg,
      ));
    }

    Map<int, RaceBracket> bracketMap =
    globals.globalDerby.getRaceBrakcetCache();
    print("getBracketListBody2: ${bracketMap.length}");
    bracketMap.forEach(add1Bracket);

    return RefreshIndicator(
        onRefresh: globals.globalDerby.refreshStatus.doRefresh,
        child: new ListView(
          children: bracketWidgetList,
        ));
  }


}

