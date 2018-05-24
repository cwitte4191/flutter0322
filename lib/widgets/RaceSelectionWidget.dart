import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/RaceSelection2.dart';
import 'package:flutter0322/appPages/RacerApp.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/globals.dart' as globals;

class RaceSelectionWidget extends StatelessWidget {
  final double f1 = 1.8;
  final String displayFile;
  final String fullPath;
  final Color bgColor;
  final String displayedText;
  RaceSelectionWidget({Key, key, this.displayFile, this.fullPath, this.bgColor})
      : assert(displayFile != null),
        assert(fullPath != null),
        displayedText = formatDisplayedText(displayFile),
        super(key: key) {}
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
                  child: new Text(displayedText,
                      textAlign: TextAlign.left, textScaleFactor: f1),
                ),
              ],
            )));
  }

  static String formatDisplayedText(final String candidateString) {
    String displayedText = candidateString;
    displayedText = displayedText.replaceAll(new RegExp(r".xml"), "");
    displayedText = displayedText.replaceAll(new RegExp(r".cfg"), "");
    return displayedText;
  }

  void _onLoading(BuildContext context) {
    showDialog(context: context, child: getLoadingDialog());
  }

  static Widget getLoadingDialog() {
    return new Dialog(
        child: new Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[new CircularProgressIndicator(), new Text("Loading")],
    ));
  }

  void handleTap(BuildContext context) async {
    Map<String, Racer> racerModelMap = new Map();

    print("Tapped: ${fullPath}");
    _onLoading(context);
    String response = await new GetS3Object().getS3ObjectAsString(fullPath);
    RaceConfig raceConfig = RaceConfig.fromXml(response, raceName: displayedText);

    if (raceConfig.applicationUrl.isEmpty) {
      print("Redisplaying list with bucket ${raceConfig.s3BucketUrlPrefix}");
      RaceSelection2.loadAndPush(context, raceConfig.s3BucketUrlPrefix);
    } else {
      globals.globalDerby = new globals.GlobalDerby(raceConfig: raceConfig);

      await globals.globalDerby.init(true);

      Map<int, Racer> racerMap =
          await new RefreshData().doRefresh(raceConfig: raceConfig);
      //globals.globalDerby.derbyDb.testBroadcastSink();

      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new RacerHome()));
    }
  }
}
