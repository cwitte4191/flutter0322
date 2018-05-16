import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/BracketList.dart';
import 'package:flutter0322/appPages/RaceHistoryPage.dart';
import 'package:flutter0322/appPages/RaceSelection2.dart';
import 'package:flutter0322/appPages/RacerApp.dart';
import 'package:flutter0322/appPages/TabbedBracket.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/testData.dart';

import 'package:flutter0322/globals.dart' as globals;

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
            onTap: () async {
              Map<int, RacePhase> phaseMap = null;
              if (globals.globalDerby.raceConfig != null) {
                phaseMap = await new RefreshData().doRefresh("RacePhase");
              }
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new RaceHistoryPage(racePhaseMap: phaseMap)));
            },
          ),
          new ListTile(
            title: new Text('Race Heats'),
            onTap: () async {
              Map<int, RaceStanding> standingMap = null;
              if (globals.globalDerby.raceConfig != null) {
                standingMap = await new RefreshData().doRefresh("RaceStanding");
              }
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new RaceHistoryPage(raceStandingMap: standingMap)));
            },
          ),
          new ListTile(
            title: new Text('Racers'),
            onTap: () async {
              Map<int, Racer> racerMap = null;
              if (globals.globalDerby.racerMap.length==0) {
                racerMap = await new RefreshData().doRefresh("Racer");
              } else {
                racerMap=globals.globalDerby.racerMap;
              }
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RacerHome(racerMap: racerMap)));
            },
          ),
          new ListTile(
            title: new Text('Race Selection'),
            onTap: () {
              RaceSelection2.loadAndPush(context);
            },
          ),

          new ListTile(
            title: new Text('Brackets'),
            onTap: () async {
              Map<int, RaceBracket> bracketMap = null;
              if (globals.globalDerby.raceConfig != null) {
                if(globals.globalDerby.bracketMap.length==0) {
                  print("Refreshing bracketMap");

                  bracketMap = await new RefreshData().doRefresh("RaceBracket");
                }
                else{
                  bracketMap=globals.globalDerby.bracketMap;
                  print("Using cached bracketMap");

                }
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new BracketList(bracketMap: bracketMap)));
              }
              else{
                print("Null raceConfig, no brackets allowed");
              }
            },
          ),
        ],
      ),
    );
  }
}
