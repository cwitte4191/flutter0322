import 'package:flutter/material.dart';
import 'package:flutter0322/globals.dart' as globals;

class FilterRowWidget extends StatefulWidget {
  final Type triggerTable;
  FilterRowWidget({this.triggerTable});
  @override
  State<StatefulWidget> createState() {
    return new FilterRowWidgetState(triggerTable: this.triggerTable);
  }
}

class FilterRowWidgetState extends State<FilterRowWidget> {
  TextEditingController _controller;
  final Type triggerTable;

  FilterRowWidgetState({this.triggerTable});
  @override
  void initState() {
    super.initState();

    _controller =
        new TextEditingController(text: globals.globalDerby.sqlCarNumberFilter);
  }

  @override
  Widget build(BuildContext context) {
    String filter = globals.globalDerby.sqlCarNumberFilter;

    return new Row(
      children: <Widget>[
        new Icon(Icons.filter_list, size: 48.0),
        new Container(width: 30.0),
        new Container(
            width: 75.0,
            child: new TextField(
              autofocus: false,
              maxLength: 3,
              controller: _controller,
              onSubmitted: applyCarFilter,
              onChanged: applyCarFilter,
              keyboardType: TextInputType.number,
              decoration: new InputDecoration(
                  //labelText: 'CarNumber',
                  hintText: 'Car Filter'),
            )),
      ],
    );
  }

  void applyCarFilter(String carFilter) {
    //skip already processed changes.
    if(carFilter == globals.globalDerby.sqlCarNumberFilter) return;

    globals.globalDerby.sqlCarNumberFilter = carFilter;
    globals.globalDerby.derbyDb.recentChangesController
        .add(triggerTable.toString());
  }
}
