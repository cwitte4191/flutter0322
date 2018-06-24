import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';
import 'package:flutter0322/globals.dart';

class LoginDialog extends StatefulWidget {




  @override
  LoginDialogState createState() => new LoginDialogState();

  static showLoginDialog(BuildContext context){
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new LoginDialog();
        },
        fullscreenDialog: true));
  }
}

class LoginDialogState extends State<LoginDialog> {

  var carStyle=const TextStyle(fontSize: 36.0, color: Colors.black);


  @override
  void initState() {
    // _lane1Car = widget.raceBracket.raceName;

    super.initState();
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Login"),
          actions: [
            new FlatButton(
                onPressed: () {
                  // TODO: save cars on server!
                  Navigator.of(context).pop();
                },
                child: new Text('Login',
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white))),
          ],
        ),
        body:
        new Column(children: [
          getUserTile(),
          getPasswordTile(),
        ],
        ));
  }

  Widget getUserTile(){

    return new ListTile(
      leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
      title: new TextFormField(
        decoration: new InputDecoration(
          hintText: 'User',
        ),
        keyboardType:TextInputType.text,
        autovalidate: true,
        style: carStyle,
        autofocus: true,
        validator: fakeLogin,

      ),
    );
  }
  Widget getPasswordTile(){

    return new ListTile(
      leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
      title: new TextFormField(
        decoration: new InputDecoration(
          hintText: 'Password',
        ),
        keyboardType:TextInputType.text,
        autovalidate: true,
        style: carStyle,
        autofocus: false,
      ),
    );
  }

  String fakeLogin(String user) {
    user=user.toLowerCase();
    Map<String,LoginRole>fakeMap={
      "ttt":LoginRole.Timer,
      "sss":LoginRole.Starter,
      "aaa":LoginRole.Admin,
      "nnn":LoginRole.None,
    };

    if(fakeMap.containsKey(user)){
      print("setting user to: ${fakeMap[user]}");
      InheritedLoginWidget ilw=InheritedLoginWidget.of(context);
      ilw.loginCredentials=new LoginCredentials(loginRole:fakeMap[user]);
    }

  }

}