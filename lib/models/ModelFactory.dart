import 'dart:async';
import 'dart:convert';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/globals.dart' as globals;

class ModelFactory {
  static Future<HasRelational> loadDb(String jsonString) async {
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
        RaceBracket rb=rc as RaceBracket;
        print ("ModelFactory: ${rb.jsonDetail}");

        if((rc as RaceBracket).id ==null){
          rc=null;
        }
    }

    //print("ModelFactory: publishing:  $rc");

    //if (rc != null) globals.globalDerby.derbyDb.fromNetworkController.add(rc);
    if (rc != null) {
      await globals.globalDerby.derbyDb.addNewModel(rc);
    }
    return rc;
  }

  static int boolAsInt(bool isDeleted) {
    return (isDeleted ? 1 : 0);
  }
}
