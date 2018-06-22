import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/DbRefreshAid.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/widgets/FilterRowWidget.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:flutter0322/globals.dart' as globals;

class RaceStandingPage extends StatefulWidget implements WidgetsWithFab {
  final HistoryType historyType;
  RaceStandingPage({this.historyType});

  @override
  State<StatefulWidget> createState() {
    return new RaceStandingPageState(historyType: historyType);
  }
  @override
  Widget getFab(BuildContext context) {
    if(this.historyType==HistoryType.Standing){
      return new Container(); // no fab for race standing!
    }
    return new FloatingActionButton(
      onPressed: ()  {
        onFabClicked(context);
      },

      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }
  void onFabClicked(BuildContext context) {
    if (!globals.globalDerby.isLoggedIn) {
      return;
    }
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AddPendingCarsDialog(historyType: historyType,);
        },
        fullscreenDialog: true));
  }
}

class RaceStandingPageState extends State<RaceStandingPage>
    implements DbRefreshAid {
  final HistoryType historyType;
  bool firstTime = true;

  RaceStandingPageState({this.historyType}) {
    DbRefreshAid.dbAidWatchForNextChange(this, "RaceStanding");
  }
  List<Map<String, dynamic>> raceStandingList = [];

  @override
  Widget build(BuildContext context) {
    Widget bodyWidgets;

    bodyWidgets = this.getRaceStandingHistoryBodyFromDB();

    return bodyWidgets;
  }

  Widget getRaceStandingHistoryBodyFromDB() {
    if (firstTime) {
      // TODO: we seem to be recurse ing w/o this!?
      queryDataFromDb();
      firstTime = false; // don't initiate query on subsequent build events.
    }

    int listSize = raceStandingList?.length;
    listSize += 1; // artificially larger for filter.

    return RefreshIndicator(
        onRefresh: globals.globalDerby.refreshStatus.doRefresh,
        child: ListView.builder(
            itemBuilder: raceStandingItemBuilder, itemCount: listSize));
  }

  Widget raceStandingItemBuilder(BuildContext context, int index) {
    if (index == 0) {
      return new FilterRowWidget(triggerTable: RaceStanding);
    } else {
      index = index - 1;
    }

    RaceStanding raceStanding =
        new RaceStanding.fromSqlMap(raceStandingList[index]);

    RaceStandingUi raceStandingUi = new RaceStandingUi(raceStanding);
    RaceResultWidget rrw =
        new RaceResultWidget(displayableRace: raceStandingUi);
    return rrw;
  }

  @override
  bool queryDataFromDb() {
    bool getPending = (historyType == HistoryType.Pending);
    globals.globalDerby.derbyDb?.database
        ?.rawQuery(RaceStanding.getSelectSql(
            getPending: getPending,
              carFilter: globals.globalDerby.sqlCarNumberFilter))
        ?.then((list) {
      print("RaceStanding: repopulateList! $list");

      if (this.mounted) {
        setState(() {
          raceStandingList = list;
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



class AddPendingCarsDialog extends StatefulWidget {
  final HistoryType historyType;
   String title;

  AddPendingCarsDialog({this.historyType}):assert(historyType!=null){
    setTitle();
  }

  @override
  AddPendingCarsDialogState createState() => new AddPendingCarsDialogState();
   void setTitle(){
     title="";
     if(historyType==HistoryType.Pending){
       title="Add Pending Race";
     }
     if(historyType==HistoryType.Phase){
       title="Cars on Ramp";
     }
  }
}

class AddPendingCarsDialogState extends State<AddPendingCarsDialog> {
  TextEditingController __lane1Controller;
  TextEditingController __lane2Controller;

  var _lane1Car;
  var _lane2Car;

  @override
  void initState() {
    // _lane1Car = widget.raceBracket.raceName;
    __lane1Controller = new TextEditingController(text: "");
    __lane2Controller = new TextEditingController(text: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.historyType==HistoryType.Standing){

    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: [
          new FlatButton(
              onPressed: () {
                //TODO: Handle save
              },
              child: new Text('SAVE',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Colors.white))),
        ],
      ),
      body:
      new Column(children: <Widget>[
      new ListTile(
        leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
        title: new TextFormField(
          decoration: new InputDecoration(
            hintText: 'Car Number 1',
          ),
          controller: __lane1Controller,
          //onChanged: (value) => _lane1Car = value,
            keyboardType:TextInputType.number,
          maxLength:3,
          onSaved: _lane1Car,
          validator: derbyCarOnly,
          autovalidate: true,

        ),
      ),
      new ListTile(
        leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
        title: new TextFormField(
          decoration: new InputDecoration(
            hintText: 'Car Number 2',
          ),
          controller: __lane2Controller,
          keyboardType:TextInputType.number,
          maxLength:3,
          onSaved: _lane2Car,
          validator: derbyCarOnly,
          autovalidate: true,



        ),
      ),
    ]
    ));
  }
  String derbyCarOnly(String x){
    print("derby validator $x");

      if(x.length<3){
        return "Car Number Should be 3 digits long";
      }
  }
}