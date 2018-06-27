import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';

class MyInheritedTabWidget extends StatefulWidget {
  Widget child;
  HistoryType initialHistoryType;
  MyInheritedTabWidget({@required HistoryType this.initialHistoryType,@required this.child});

  @override
  MyInheritedTabState createState() => new MyInheritedTabState(initialHistoryType: initialHistoryType);

  static MyInheritedTabState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyInheritedTab) as _MyInheritedTab).data;
  }
}

class MyInheritedTabState extends State<MyInheritedTabWidget> {
  HistoryType _myField;
  // only expose a getter to prevent bad usage
  HistoryType get myField => _myField;

  MyInheritedTabState({@required HistoryType initialHistoryType}):this._myField=initialHistoryType;
  void doHistoryTypeChange(HistoryType newValue) {
    setState(() {
      _myField = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _MyInheritedTab(
      data: this,
      child: widget.child,
    );
  }
}

/// Only has MyInheritedState as field.
class _MyInheritedTab extends InheritedWidget {
  final MyInheritedTabState data;

  _MyInheritedTab({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MyInheritedTab old) {
    return true;
  }
}