import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/derbyBodyWidgets.dart';
import 'package:flutter0322/network/GetS3Object.dart';

class RaceSelection2 extends StatelessWidget {
  final String title;
  final Map<String, String> flist;
  RaceSelection2({this.title = "Race Selection", this.flist});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new DerbyBodyWidgets().getRaceSelectionBody(flist),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  static loadAndPush(BuildContext context,
      [String s3BucketName =
          "https://s3.amazonaws.com/all.derby.rr1.us"]) async {
    var flist = await new GetS3Object().getS3BucketList(s3BucketName);

    print("loadAndPush: " + flist.toString());
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new RaceSelection2(flist: flist)));
  }
}
