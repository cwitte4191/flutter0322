import 'package:flutter/material.dart';
import 'package:flutter0322/appPages/TabbedRaceHistory.dart';

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

  final int laneCount=2;

  List<TextEditingController> __editControllerList=[];

  List<FocusNode> _focusNodeList=new List<FocusNode>();
  List<dynamic> _laneCarList=[];


  var carStyle=const TextStyle(fontSize: 36.0, color: Colors.black);

  //ChangeRecord c;
  //Observable l1co=new Observable<ChageRecord>(_lane1Car);

  @override
  void initState() {
    // _lane1Car = widget.raceBracket.raceName;


    print ("AddPendingController initState");
    for(int laneNumber=0;laneNumber<laneCount;laneNumber++){
      __editControllerList.add(new TextEditingController(text:""));
      _focusNodeList.add(new FocusNode());
      _laneCarList.add("");

    }




    super.initState();
  }
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    _focusNodeList.forEach((node)=>node.dispose());

    super.dispose();
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
                  // TODO: save cars on server!
                  Navigator.of(context).pop();
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
        new Column(children: getInputTiles(),
        ));
  }
  List<Widget> getInputTiles(){
    List<Widget> rc=[];
    for(int idx=0;idx<laneCount;idx++) {
       rc.add(getInputTile(laneNumber: idx+1));
    }
      return rc;
  }
  Widget getInputTile({int laneNumber}){
    int laneIndex=laneNumber-1;
    bool autoFocusBoolean=(laneIndex==0);

    return new ListTile(
      leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
      title: new TextFormField(
        decoration: new InputDecoration(
          hintText: 'Lane Number $laneNumber',
        ),
        controller: __editControllerList[laneIndex],
        keyboardType:TextInputType.number,
        maxLength:3,
        //onSaved: _laneCarList[laneIndex],
        validator: derbyCarOnly,
        autovalidate: true,
        style: carStyle,
        autofocus: autoFocusBoolean,
        focusNode: _focusNodeList[laneIndex],



      ),
    );
  }
  String derbyCarOnly(String x){
    print("derby validator $x");

    if(x.length<3){
      return "Car Number Should be 3 digits long";
    }
    else{
      if(_focusNodeList[0].hasFocus && laneCount > 1){
        FocusScope.of(context).requestFocus(_focusNodeList[1]);
      }
      /*
      if(__focusNode2.hasFocus){
        FocusScope.of(context).requestFocus(__focusNode1);
      }
      else{
        FocusScope.of(context).requestFocus(__focusNode2);
      }
      */
    }
    return "";
  }
}