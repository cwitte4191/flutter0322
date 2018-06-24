import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/TabbedBracket.dart';
import 'package:flutter0322/globals.dart';
import 'package:flutter0322/modelUi.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/globals.dart' as globals;

class RaceBracketWidget extends StatelessWidget {
  final double f1 = 1.8;
  final RaceBracket raceBracket;
  final Color bgColor;
  RaceBracketWidget({Key, key, this.raceBracket, this.bgColor})
      : assert(raceBracket != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () {
          handleTap(context);
        },
        onLongPress: () {
          handleLongPress(context);
        },
        child: new Container(
            color: bgColor,
            child: new Row(
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.all(18.0),
                    child: new Text(raceBracket.raceName,
                        textAlign: TextAlign.left,
                        textScaleFactor: f1,
                        style: new TextStyle(fontWeight: FontWeight.bold))),
                new Padding(
                    padding: new EdgeInsets.all(18.0),
                    child: new Text(raceBracket.raceStatus,
                        textAlign: TextAlign.left, textScaleFactor: f1)),
              ],
            )));
  }

  void handleTap(BuildContext context) async {
    print("Tapped: ${raceBracket.raceName}");
    print("json: ${raceBracket.jsonDetail}");

    RaceBracketDetail rbd =
        RaceBracketDetail.fromJsonMap(JSON.decode(raceBracket.jsonDetail));
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new TabbedBracket(new RaceBracketDetailUi(rbd))));
  }

  void handleLongPress(BuildContext context) {
    final InheritedLoginWidget inheritedLoginWidget = InheritedLoginWidget.of(context);

    print ("inherited credentials widget2: ${inheritedLoginWidget.loginCredentials.loginRole}");
    if (inheritedLoginWidget.loginCredentials.canChangeBracketName()) {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new EditRaceBracketDialog(raceBracket);
          },
          fullscreenDialog: true));
    }
  }
}

class EditRaceBracketDialog extends StatefulWidget {
  final RaceBracket raceBracket;
  EditRaceBracketDialog(this.raceBracket);
  @override
  EditRaceBracketDialogState createState() => new EditRaceBracketDialogState();
}

class EditRaceBracketDialogState extends State<EditRaceBracketDialog> {
  TextEditingController __rbtController;

  var _raceBracketTitle;

  @override
  void initState() {
    _raceBracketTitle = widget.raceBracket.raceName;
    __rbtController = new TextEditingController(text: _raceBracketTitle);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Edit Race Bracket'),
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
      body: new ListTile(
        leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
        title: new TextField(
          decoration: new InputDecoration(
            hintText: 'RaceBracket Title',
          ),
          controller: __rbtController,
          onChanged: (value) => _raceBracketTitle = value,
        ),
      ),
    );
  }
}
