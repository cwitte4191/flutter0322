import 'package:flutter/material.dart';
import 'package:flutter0322/DerbyNavDrawer.dart';
import 'package:flutter0322/derbyBodyWidgets.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/network/GetS3Object.dart';
import 'package:flutter0322/globals.dart' as globals;
import 'package:flutter0322/widgets/RacerWidget.dart';

class RacerHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new RacerHomeState();
  }
}

class RacerHomeState extends State<RacerHome> {
  final String title;
  List<Map<String,dynamic>> racerDbMap=[];

  BuildContext lastContext;
  RacerHomeState({this.title="Racers"});

  @override
  Widget build(BuildContext context) {
    print("RacerHomeState build db length:  ${racerDbMap.length}");

    lastContext=context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: getRacerListBodyFromDB(),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>

          requestRefresh(context)
        ,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void requestRefresh(BuildContext context) async{
    Map<int,Racer> racerMap=await new RefreshData().doRefresh( );
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new RacerHome()));
  }




  Widget racerItemBuilder(BuildContext context, int index) {
    print("racerItemBuilder $index of ${racerDbMap.length}");
    Color bg = index % 2 == 0 ? Colors.grey : null;

    Racer racer=new Racer.fromSqlMap(racerDbMap[index]);
    print("racerItemBuilder $index racer: ${racer.toJson()}");

    Racer testr=new Racer()..carNumber=997..racerName="testr $index";
    return new RacerWidget(
      racer: racer,
      bgColor: bg,
    );
  }

  Widget getRacerListBodyFromDB() {
    void repopulate(final List<Map<String, dynamic>> list2 ) {
      print("repopulateList! $list2");

      setState(() {racerDbMap=list2; });
    }
    if(racerDbMap?.length==0) {// TODO: we seem to be recursing w/o this!?
      globals.globalDerby.derbyDb?.database?.rawQuery(Racer.getSelectSql())
          ?.then((list) => repopulate(list));
    }


    return ListView.builder(
        itemBuilder: racerItemBuilder, itemCount: racerDbMap?.length);
  }

}

