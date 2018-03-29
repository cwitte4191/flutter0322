import 'package:flutter/material.dart';
import '../models/racer.dart';
import '../network/GetS3Object.dart';
class ChartListWidget extends StatelessWidget {
  final double f1 = 1.8;
  final String displayFile;
  final String fullPath;
  final Color bgColor;
  ChartListWidget({Key, key, this.displayFile, this.fullPath, this.bgColor})
      : assert(displayFile != null),
        assert(fullPath != null),
        super(key: key) {}
  @override
  Widget build(BuildContext context) {
    String truncateDf = displayFile;
    truncateDf = truncateDf.replaceAll(new RegExp(r".xml"), "");
    truncateDf = truncateDf.replaceAll(new RegExp(r".cfg"), "");
    print("trucateDf: ${truncateDf}");
    return new GestureDetector(
        onTap: () {
          print("Tapped: ${fullPath}");
          new GetS3Object().getS3Object(fullPath);
        },
        child: new Container(
            color: bgColor,
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(18.0),
                  child: new Text(truncateDf,
                      textAlign: TextAlign.left, textScaleFactor: f1),
                ),
              ],
            )));
  }
}
