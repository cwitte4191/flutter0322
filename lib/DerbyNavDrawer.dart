import 'package:flutter/material.dart';
import 'testData.dart';
import 'appPages/RacerApp.dart';
import 'appPages/RaceHistoryApp.dart';
import 'appPages/RaceSelectionApp.dart';
import 'models/RaceBracketDetail.dart';
import 'main.dart';
import 'appPages/tab2.dart';

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
              var racerList=new TestData().getTestRacers();
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new RacerApp(racerList: racerList)));
            },
          ),
          new ListTile(
            title: new Text('Race Selection'),
            onTap: () {

              RaceSelectionApp.loadAndPush(context);
            },
          ),
          new ListTile(
            title: new Text('Bracket with Tabs'),
            onTap: () {

              RaceBracketDetail rbd=new TestData().getRbd();

              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new TabBarDemo(rbd)));
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

}
