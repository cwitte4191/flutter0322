import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/TabbedBracket.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';

class RaceBracketWidget extends StatelessWidget {
  final double f1 = 1.8;
  final RaceBracket raceBracket;
  final Color bgColor;
  RaceBracketWidget({Key, key, this.raceBracket,this.bgColor})
      : assert(raceBracket != null),
        super(key: key) ;
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {

          handleTap(context);
        },
    child: new Container(
        color: bgColor,
        child: new Row(
          children: <Widget>[
            new Padding(
                padding: new EdgeInsets.all(18.0),
                child: new Text(raceBracket.raceName,
                    textAlign: TextAlign.left,
                    textScaleFactor: f1,
                    style: new TextStyle(fontWeight: FontWeight.bold))),
            new Padding(
                padding: new EdgeInsets.all(18.0),
                child: new Text(raceBracket.raceStatus,
                    textAlign: TextAlign.left, textScaleFactor: f1)),
          ],
        )));
  }
  void handleTap (BuildContext context) async{

    print("Tapped: ${raceBracket.raceName}");
    print("json: ${raceBracket.jsonDetail}");

    RaceBracketDetail rbd=RaceBracketDetail.fromJsonMap(JSON.decode(raceBracket.jsonDetail));
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
            new TabbedBracket(new RaceBracketDetailUi(rbd))));

  }

}



