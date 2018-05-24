import 'dart:convert';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/globals.dart' as globals;

class ModelFactory {
  static HasRelational loadDb(String jsonString) {
    var foo = JSON.decode(jsonString);
    if (foo["type"] == "Remove") {
      foo["isDeleted"] = 1; // integer for interop with sqlite
    }

    //print("ModelFactory: loadDb $jsonString");

    String serializedName = foo["sn"];

    HasRelational rc;
    switch (serializedName) {
      case "Racer":
        rc = new Racer.fromJsonMap(foo["data"]);
        break;
      case "RacePhase":
        rc = new RacePhase.fromJsonMap(foo["data"]);
        break;
      case "RaceStanding":
        rc = new RaceStanding.fromJsonMap(foo["data"]);
        break;
      case "RaceBracket":
        rc = new RaceBracket.fromJsonMap(foo["data"]);
    }

    //print("ModelFactory: publishing:  $rc");

    if (rc != null) globals.globalDerby.derbyDb.fromNetworkController.add(rc);

    return rc;
  }

  static int boolAsInt(bool isDeleted) {
    return (isDeleted ? 1 : 0);
  }
}
