import 'package:flutter/material.dart';
import '../models.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RaceResultWidget extends StatelessWidget {
  final double f1 = 1.8;
  final DisplayableRace displayableRace;
  final Map<int, String> driverMap;
  RaceResultWidget({Key, key, this.displayableRace, this.driverMap})
      : assert(displayableRace != null),
        super(key: key) {}

  @override
  Widget build(BuildContext context) {
    var tcw = new Map<int, TableColumnWidth>();
    tcw[0] = new FractionColumnWidth(0.25);

    Widget tableWidget = new Table(
        columnWidths: tcw,
        //border: new TableBorder.all(),
        children: getChildTableRows(displayableRace, driverMap));
    return new Card(child: tableWidget);
  }

  static Widget _getLakeWidget() {
    print("getLakeWidget");
    return new Image.network(
        'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
        height: 50.0,
        width: 50.0);
  }

  static Widget _getCachedLakeWidget() {
    return new CachedNetworkImage(
      placeholder: new CircularProgressIndicator(),
      imageUrl:
          'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
    );
  }

  static Widget getFinishFlagWidget() {
    if (true) {
      return _getCachedLakeWidget();
      return _getLakeWidget();
    }
    return new DecoratedBox(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("images/finish_flag.png"))));
  }

  getChildTableRows(DisplayableRace displayableRace, Map driverMap) {
    var rc = [];

    var resultsSummary = new ResultsSummary();
    displayableRace.getResultsSummary(resultsSummary);

    for (var carNumber in displayableRace.getCarNumbers()) {
      var driverName = driverMap[carNumber];

      //print("raceEntry car:"+raceEntry.carNumber.toString());
      //print("raceEntry driver:"+driverMap.values.toString());
      //print("raceEntry driver:"+driverName);
      //resultsSummary[raceEntry].add("foo");
      rc.add(new TableRow(children: <Widget>[
        //new Text("foo"),
        getFinishFlagWidget(),
        new DriverResultWidget(
            driverName: driverMap[carNumber],
            carNumber: carNumber,
            supplementalText: resultsSummary.getMessages(carNumber))
      ]));
    }
    return rc;
    /*
    return [
      new TableRow(children: <Widget>[
        //getFinishFlagWidget(),
        new Text("foo"),
        new DriverResultWidget("Driver A", carNumber: 222)
      ]),
      new TableRow(children: <Widget>[
        new Text("bar"),
        new DriverResultWidget("Driver B", carNumber: 223)
      ]),
    ];
    */
  }
}

class DriverResultWidget extends StatelessWidget {
  final String driverName;
  final int carNumber;
  final List<String> supplementalText;
  const DriverResultWidget(
      {Key, key, this.carNumber, this.driverName, this.supplementalText})
      : super(key: key);
/*
  DriverResultWidget.fromRacePhase(RacePhase rp): this.carNumber{

  }
  */
  @override
  Widget build(BuildContext context) {
    double f1 = 1.8;
    var safeDriverName = driverName;

    if (safeDriverName == null) {
      safeDriverName = "";
    }

    String safeCarNumber=carNumber.toString();
    if(carNumber >=9000 && carNumber<=10000 ){
      safeCarNumber="Bye";
    }
    var rowWidgets = [];
    rowWidgets.add(new Row(children: <Widget>[
      new Text(
        safeCarNumber,
        textAlign: TextAlign.left,
        style: new TextStyle(fontWeight: FontWeight.bold),
        textScaleFactor: 3.0,
      ),
      new Padding(
          padding: new EdgeInsets.all(18.0),
          child: new Text(safeDriverName,
              textAlign: TextAlign.left, textScaleFactor: f1)),
    ]));
    for (String supText in this.supplementalText) {
      rowWidgets.add(new Row(children: <Widget>[
        new Text(
          supText,
          textAlign: TextAlign.left,
          textScaleFactor: f1,
        ),
      ]));
    }

    return new Column(
      children: rowWidgets,
    );
  }
}
