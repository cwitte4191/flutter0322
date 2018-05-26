import 'dart:convert';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/globals.dart' as globals;

class ModelFactory {
  static HasRelational loadDb(String jsonString) {
    var jsonMap = JSON.decode(jsonString);
    if (jsonMap["type"] == "Remove") {
      jsonMap["data"]["isDeleted"]=1; // integer for interop with sqlite
    }

    //print("ModelFactory: loadDb $jsonString");

    String serializedName = jsonMap["sn"];

    HasRelational rc;
    switch (serializedName) {
      case "Racer":
        rc = new Racer.fromJson(jsonMap["data"]);
        break;
      case "RacePhase":
        rc = new RacePhase.fromJsonMap(jsonMap["data"]);
        break;
      case "RaceStanding":
        rc = new RaceStanding.fromJsonMap(jsonMap["data"]);
        break;
      case "RaceBracket":
        rc = new RaceBracket.fromJsonMap(jsonMap["data"]);
        if((rc as RaceBracket).id ==null){
          rc=null;
        }
    }

    //print("ModelFactory: publishing:  $rc");

    if (rc != null) globals.globalDerby.derbyDb.fromNetworkController.add(rc);

    return rc;
  }

  static int boolAsInt(bool isDeleted) {
    return (isDeleted ? 1 : 0);
  }
}
