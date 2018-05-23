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
                          new RaceHistoryPage(historyType: HistoryType.Phase)));
            },
          ),
          new ListTile(
            title: new Text('Race Heats'),
            onTap: () async {
              Map<int, RaceStanding> standingMap = null;
              if (globals.globalDerby.raceConfig != null) {
                standingMap = await new RefreshData(refreshFilter: RaceStanding.isNotPending).doRefresh("RaceStanding");
              }
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new RaceHistoryPage(raceStandingMap: standingMap)));
            },
          ),
          new ListTile(
            title: new Text('Pending Races'),
            onTap: () async {
              Map<int, RaceStanding> standingMap = null;
              Map<int, RaceStanding> pendingMap = {};
              void filterRS(int key, RaceStanding rs){
                if(rs.phase2DeltaMS==null){
                  pendingMap[key]=rs;
                }
              }
              if (globals.globalDerby.raceConfig != null) {
                standingMap = await new RefreshData(refreshFilter: RaceStanding.isPending).doRefresh("RaceStanding");
                //standingMap.forEach(filterRS);
              }
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                      new RaceHistoryPage(racePendingMap: standingMap)));
            },
          ),
          new ListTile(
            title: new Text('Racers'),
            onTap: () async {
              Map<int, Racer> racerMap = await new RefreshData().doRefresh("Racer");

              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new RacerHome()));
            },
          ),


          new ListTile(
            title: new Text('Brackets'),
            onTap: () async {
              if (globals.globalDerby.raceConfig != null) {
                Map<int, RaceBracket> bracketMap = await new RefreshData().doRefresh("RaceBracket");

                /*
                if(globals.globalDerby.bracketMap.length==0) {
                  print("Refreshing bracketMap");

                  bracketMap = await new RefreshData().doRefresh("RaceBracket");
                }
                else{
                  bracketMap=globals.globalDerby.bracketMap;
                  print("Using cached bracketMap");

                }
                */
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
          new ListTile(
            title: new Text('Race Selection'),
            onTap: () {
              RaceSelection2.loadAndPush(context);
            },
          ),
        ],
      ),
    );
  }
}
