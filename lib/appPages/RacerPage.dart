import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:flutter0322/widgets/RacerWidget.dart';

class RacerHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RacerHomeState();
  }
}

class RacerHomeState extends State<RacerHome> implements DbRefreshAid {
  final String title;
  List<Map<String, dynamic>> racerDbMap = [];

  bool firstTime=true;
  BuildContext lastContext;
  RacerHomeState({this.title = "Racers"}) {
    DbRefreshAid.dbAidWatchForNextChange(this, "Racer");
  }

  @override
  Widget build(BuildContext context) {
    print("RacerHomeState build db length:  ${racerDbMap.length}");

    lastContext = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: getRacerListBodyFromDB(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => requestRefresh(context),
        tooltip: 'Refresh',
        child: new Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void requestRefresh(BuildContext context) async {
    print("requestRefresh!");
    await new RefreshData().doRefresh();
    //Navigator.push(context,
    //  new MaterialPageRoute(builder: (context) => new RacerHome()));
  }

  Widget racerItemBuilder(BuildContext context, int index) {
    //print("racerItemBuilder $index of ${racerDbMap.length}");
    Color bg = index % 2 == 0 ? Colors.grey : null;

    Racer racer = new Racer.fromJson(racerDbMap[index]);
    //print("racerItemBuilder $index racer: ${racer.toJson()}");

    return new RacerWidget(
      racer: racer,
      bgColor: bg,
    );
  }

  Widget getRacerListBodyFromDB() {
    //if (racerDbMap?.length == 0) {
    if(firstTime){
      // TODO: we seem to be recurse ing w/o this!?
      queryDataFromDb();
      firstTime=false; // don't initiate query on subsequent build events.
    }

    return ListView.builder(
        itemBuilder: racerItemBuilder, itemCount: racerDbMap?.length);
  }

  @override
  bool queryDataFromDb() {
    globals.globalDerby.derbyDb?.database
        ?.rawQuery(Racer.getSelectSql())
        ?.then((list) {
      print("queryDataFromDb repopulate Racers! ${list.length}");

      if (mounted) {
        setState(() {
          racerDbMap = list;
        });
      }
    });
    return this.mounted;
  }
  @override
  bool isWidgetMounted() {
    return this.mounted;
  }
}
