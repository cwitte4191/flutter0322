import 'package:flutter/material.dart';

class FocusVisibilityDemo extends StatefulWidget {
  @override
  _FocusVisibilityDemoState createState() => new _FocusVisibilityDemoState();
}

class _FocusVisibilityDemoState extends State<FocusVisibilityDemo> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Text Dialog Demo')),
      body: new Center(
        child: new RaisedButton(
          onPressed: _showDialog,
          child: new Text("Push Me"),
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                onSubmitted: ((String foo)=>print("submitted: $foo")),
                decoration: new InputDecoration(
                    labelText: 'Full Name', hintText: 'eg. John Smith'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OPEN'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}