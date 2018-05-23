import 'dart:convert';

import 'package:flutter0322/models.dart';
import 'package:flutter0322/globals.dart' as globals;

class ModelFactory {
  static void loadDb(String jsonString) {
    var foo = JSON.decode(jsonString);
    print ("ModelFactory: loadDb $jsonString");
    bool isDeleted = foo["type"] == "Remove";

    String serializedName = foo["sn"];

    if (serializedName == "Racer") {
      Racer r = new Racer.fromJsonMap(foo["data"]);
      globals.globalDerby.derbyDb.execute(r.generateSql(_isDeletedAsInt(isDeleted)));
      return;
    }

    if (serializedName == "RacePhase") {
      RacePhase r = new RacePhase.fromJsonMap(foo["data"]);

      globals.globalDerby.derbyDb.execute(r.generateSql(_isDeletedAsInt(isDeleted)));
      return;
    }
    if (serializedName == "RaceStanding") {
      RaceStanding r = new RaceStanding.fromJsonMap(foo["data"]);
      globals.globalDerby.derbyDb.execute(r.generateSql(_isDeletedAsInt(isDeleted)));
    }
    if (serializedName == "RaceBracket") {
      RaceBracket r = new RaceBracket.fromJsonMap(foo["data"]);

      if (r.id == null) {
        // happens on persist, ,not merge!?
        return;
      }
      globals.globalDerby.derbyDb.execute(r.generateSql(_isDeletedAsInt(isDeleted)));
    }
  }
  static int _isDeletedAsInt(bool isDeleted) {
    return(isDeleted?1:0);
  }
}
