import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/RaceResultWidget.dart';
import '../DerbyNavDrawer.dart';
import '../derbyBodyWidgets.dart';
import 'dart:async';
import '../network/GetS3Object.dart';

class RaceSelectionApp extends StatelessWidget {
  // This widget is the root of your application.
  Timer timer;
  final Map<String, String> flist;

  RaceSelectionApp({this.flist}) {}

  @override
  Widget build(BuildContext context) {
    _runTimer();
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Races List', flist: flist),
    );
  }

  _runTimer() {
    const timeout = const Duration(seconds: 3);
    const ms = const Duration(milliseconds: 1);
    void handleTimeout() {
      // callback function
      print("timeout: " + new DateTime.now().millisecondsSinceEpoch.toString());
    }

    startTimeout([int milliseconds]) {
      var duration = milliseconds == null ? timeout : ms * milliseconds;
      return new Timer(duration, handleTimeout);
    }

    timer = startTimeout(2000);
  }

  static loadAndPush(BuildContext context) async {
    var flist=await new GetS3Object().getS3BucketList("all.derby.rr1.us");

    print("loadAndPush: "+flist.toString());
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new RaceSelectionApp(flist:flist)));
  }

}

class MyHomePage extends StatefulWidget {
  final Map<String, String> flist;

  MyHomePage({Key key, this.title, this.flist}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState(flist);
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, String> flist;
  _MyHomePageState(this.flist) {}
  void _setFlist(Map<String, String> flist) {
    this.flist = flist;
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  void _incrementCounter() {}
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
        title: new Text(widget.title),
      ),
      drawer: DerbyNavDrawer.getDrawer(context),
      body: new DerbyBodyWidgets().getChartListBody(flist),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
