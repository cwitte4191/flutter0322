import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/BracketList.dart';
import 'package:flutter0322/appPages/RaceSelection2.dart';
import 'package:flutter0322/appPages/RacerPage.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';
import 'package:flutter0322/globals.dart' as globals;

class DerbyNavDrawer {
  static Drawer getDrawer(BuildContext context) {
    String title = "Derby Menu";
    bool hasConfig = globals.globalDerby.raceConfig != null;
    if (hasConfig) {
      title = globals.globalDerby.raceConfig.raceName;
      title=(title==null)?"Derby Race":title;
    }

    List<Widget> drawerItems = [];
    drawerItems.add(new DrawerHeader(
      child: new Text(title),
      decoration: new BoxDecoration(
        color: Colors.blue,
      ),
    ));

    if (hasConfig) {
      drawerItems.add(new ListTile(
        title: new Text('Races'),
        onTap: () async {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TabbedRaceHistory()));
        },
      ));
      drawerItems.add(new ListTile(
        title: new Text('Racers'),
        onTap: () async {

          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new RacerHome()));
        },
      ));

      drawerItems.add(new ListTile(
        title: new Text('Brackets'),
        onTap: () async {

            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new BracketList()));

        }
      ));
    }

    //always allow new race selection.
    drawerItems.add(new ListTile(
      title: new Text('Race Selection'),
      onTap: () {

        RaceSelection2.loadAndPush(context);
      },
    ));
    return new Drawer(
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the Drawer if there isn't enough vertical
// space to fit everything.
      child: new ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: drawerItems,
      ),
    );
  }
}
