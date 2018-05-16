import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/derbyBodyWidgets.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';

class BracketList extends StatelessWidget {
  final String title;
  BuildContext lastContext;
  final Map<int, RaceBracket> bracketMap;
  BracketList({this.title = "Brackets", this.bracketMap}) {}

  @override
  Widget build(BuildContext context) {
    lastContext = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new DerbyBodyWidgets().getBracketListBody(bracketMap),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => print("TODO: handle press")
            //requestRefresh(context)
            ,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
