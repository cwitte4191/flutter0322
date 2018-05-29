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
  BracketList({this.title = "Brackets"}) {}

  @override
  Widget build(BuildContext context) {
    lastContext = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new DerbyBodyWidgets().getBracketListBody(),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
