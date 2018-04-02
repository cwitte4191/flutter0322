import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/RaceResultWidget.dart';
import '../DerbyNavDrawer.dart';
import '../derbyBodyWidgets.dart';
import '../testData.dart';

class RacerApp extends StatelessWidget {
  // This widget is the root of your application.
  final List<Racer> racerList;

  RacerApp({ this.racerList}){}
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new RacerHome(title: "Racers", racerList: racerList,),
    );
  }
}

class RacerHome extends StatelessWidget {


  final String title;
  final List<Racer> racerList;
  RacerHome({this.title, this.racerList});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
