import 'package:flutter/material.dart';
import 'appPages/RacerApp.dart';
import 'appPages/RaceHistoryApp.dart';
import 'appPages/RaceListApp.dart';
import 'main.dart';
import 'dart:async';
import 'network/GetS3Object.dart';

class DerbyNavDrawer {
  static Drawer getDrawer(BuildContext context) {
    return new Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the Drawer if there isn't enough vertical
// space to fit everything.
      child: new ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeader(
            child: new Text('Derby Menu'),
            decoration: new BoxDecoration(
              color: Colors.blue,
            ),
          ),
          new ListTile(
            title: new Text('Race Phases'),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RaceHistoryApp()));
            },
          ),
          new ListTile(
            title: new Text('Racers'),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new RacerApp()));
            },
          ),
          new ListTile(
            title: new Text('Brackets'),
            onTap: () {

              loadAndPush(context);
            },
          ),
        ],
      ),
    );
  }
  static loadAndPush(BuildContext context) async {
    var flist=await new GetS3Object().getS3BucketList("all.derby.rr1.us");

    print("loadAndPush: "+flist.toString());
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new RaceListApp(flist:flist)));
  }
}
