import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
//import 'package:color/color.dart';
import 'package:flutter0322/globals.dart' as globals;

class RaceResultWidget extends StatelessWidget {
  final double f1 = 1.8;
  final DisplayableRace displayableRace;
  final TextStyle timeStyle=new TextStyle(color:Colors.blueGrey);

  RaceResultWidget({Key, key, this.displayableRace})
      : assert(displayableRace != null),
        super(key: key) {}

  @override
  Widget build(BuildContext context) {
    var tcw = new Map<int, TableColumnWidth>();
    tcw[0] = new FractionColumnWidth(0.25);
    Color bgColor;
    if(displayableRace.getRaceMetaData().phaseStatus==PhaseStatus.error){
       // bgColor=HexColor('FFFF6666');
      bgColor=Colors.red;
    }
    if(displayableRace.getRaceMetaData().phaseStatus==PhaseStatus.pending){
     // bgColor=HexColor('FF7cfc00');
      bgColor=Colors.green;

    }
    Widget tableWidget = new Table(
        columnWidths: tcw,
        //border: new TableBorder.all(),
        children: getChildTableRows(displayableRace));
    return new Card(child: tableWidget, color: bgColor);
  }





  static Widget getFinishFlagWidget() {
    if (true) {
      return _getFixedFFWidget();
    }
    return new DecoratedBox(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("images/finish_flag.png"))));
  }

  static Widget _getFixedFFWidget() {
    return new Image(
        width: 60.0,
        height: 60.0,
        fit: BoxFit.scaleDown,
        image: new AssetImage("images/finish_flag.png"));
  }

  List<TableRow> getChildTableRows(DisplayableRace displayableRace) {
    Map<int,Racer> driverMap=globals.globalDerby.getRacerCache();
    var rc = new List<TableRow>();

    if (displayableRace.getRaceMetaData().chartPosition != null) {
      String cp=displayableRace.getRaceMetaData().chartPosition;
      String rbn=displayableRace.getRaceMetaData().raceBracketName;
      String updateTime=displayableRace.getRaceMetaData().raceUpdateTime;
      updateTime=(updateTime==null)?"":updateTime;
      rbn=(rbn==null)?"":rbn;
      rc.add(new TableRow(children: <Widget>[
        new Text(updateTime, style: timeStyle,),
        new Text("Heat: $cp $rbn"),

      ]));
    }
    var resultsSummary = new ResultsSummary();
    displayableRace.getResultsSummary(resultsSummary);


    // race level messages (as opposed to driver level)
    for(String raceMessage in resultsSummary.getMessages(null)){
      rc.add(new TableRow(children: <Widget>[
        new Text(""),
        new Text("$raceMessage"),

      ]));
    }
    for (var carNumber in displayableRace.getCarNumbers()) {
      if(carNumber==null){
        //continue;
      }
      var driverName = driverMap[carNumber]?.racerName;

      var iconWidget=resultsSummary.getIcon(carNumber);
      if(iconWidget==null){
        iconWidget=new Text("");
      }

      //print("raceEntry car:"+raceEntry.carNumber.toString());
      //print("raceEntry driver:"+driverMap.values.toString());
      //print("raceEntry driver:"+driverName);
      //resultsSummary[raceEntry].add("foo");
      rc.add(new TableRow(children: <Widget>[
        //new Text("foo"),
        iconWidget,


        new DriverResultWidget(
            driverName: driverName,
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
      : assert(carNumber != null),
        super(key: key);
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

    String safeCarNumber = carNumber.toString();
    if (carNumber >= 9000 && carNumber <= 10000) {
      safeCarNumber = "Bye";
    }

    //var rowWidgets=[];  //This used to work?!?!?
    List<Widget> rowWidgets = [];
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
