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

    _controller = new TextEditingController(text: globals.globalDerby.sqlCarNumberFilter);
  }
  @override
  Widget build(BuildContext context) {
    String filter=globals.globalDerby.sqlCarNumberFilter;


    return new Row(children: <Widget>[
      new Icon(Icons.filter_list,size:64.0),
      new Container(
        width:175.0,
      child:new TextField(
        autofocus: false,
        maxLength: 3,
        controller: _controller,
        onSubmitted: ((String foo) {
          print("filtering car number: $foo");
          print("filtering trigger: "+triggerTable.runtimeType.toString());
          globals.globalDerby.sqlCarNumberFilter=foo.toString();
          globals.globalDerby.derbyDb.recentChangesController.add(triggerTable.toString());

        }
        ),
        keyboardType:TextInputType.number,

        decoration: new InputDecoration(
            labelText: 'CarNumber', hintText: 'eg. 000'),

      )),
    ],);
  }
}
