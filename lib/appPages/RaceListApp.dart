import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/RaceResultWidget.dart';
import '../DerbyNavDrawer.dart';
import '../derbyBodyWidgets.dart';

class RaceListApp extends StatelessWidget {
  // This widget is the root of your application.
  final Map<String,String>flist;
  RaceListApp({this.flist}){}
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Races List', flist:flist),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Map<String,String>flist;

  MyHomePage({Key key, this.title, this.flist}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState(flist);
}

class _MyHomePageState extends State<MyHomePage> {

  Map<String,String> flist;
  _MyHomePageState(this.flist){}
  void _setFlist(Map<String,String>flist) {
    this.flist=flist;
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }




void _incrementCounter(){}
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