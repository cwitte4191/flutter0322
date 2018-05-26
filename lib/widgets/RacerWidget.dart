import 'package:flutter/material.dart';
import 'package:flutter0322/models.dart';

class RacerWidget extends StatelessWidget {
  final double f1 = 1.8;
  final Racer racer;
  final Color bgColor;
  RacerWidget({Key, key, this.racer,this.bgColor})
      : assert(racer != null),
        super(key: key) ;
  @override
  Widget build(BuildContext context) {
    //print("RacerWidget: ${racer.toJson()}");
    return new Container(
        color: bgColor,
        child: new Row(
      children: <Widget>[
        new Padding(
        padding: new EdgeInsets.all(18.0),
        child: new Text(racer.carNumber.toString(),
            textAlign: TextAlign.left,
            textScaleFactor: 3.0,
            style: new TextStyle(fontWeight: FontWeight.bold))),
        new Padding(
            padding: new EdgeInsets.all(18.0),
            child: new Text(racer.racerName,
                textAlign: TextAlign.left, textScaleFactor: f1)),
      ],
    ));
  }
}



