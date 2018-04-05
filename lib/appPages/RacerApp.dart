import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/RaceResultWidget.dart';
import '../DerbyNavDrawer.dart';
import '../derbyBodyWidgets.dart';
import '../testData.dart';

class RacerHome extends StatelessWidget {
  final String title;
  final List<Racer> racerList;
  RacerHome({this.title="Racers", this.racerList});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new DerbyBodyWidgets().getRacerListBody(racerList),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>{},
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
