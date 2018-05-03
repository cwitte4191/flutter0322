import 'package:flutter/material.dart';
import 'appPages/RaceHistoryPage.dart';
import 'testData.dart';
import 'appPages/RacerApp.dart';
import 'appPages/RaceSelection2.dart';
import 'models.dart';
import 'main.dart';
import 'appPages/TabbedBracket.dart';

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
                      builder: (context) => new RaceHistoryPage()));
            },
          ),
          new ListTile(
            title: new Text('Racers'),
            onTap: () {
              var racerMap=new TestData().getTestRacers();
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new RacerHome(racerMap: racerMap)));
            },
          ),
          new ListTile(
            title: new Text('Race Selection'),
            onTap: () {

              RaceSelection2.loadAndPush(context);
            },
          ),
          new ListTile(
            title: new Text('Bracket with Tabs'),
            onTap: () {

              var foo=[];
              for(int x=0;x<50;x++){
                foo.add(new TestData().getRbd());
              }
              RaceBracketDetail rbd=new TestData().getRbd();

              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new TabbedBracket(rbd)));
              //Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

}
