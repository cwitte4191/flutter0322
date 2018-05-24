library models;
import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter0322/models/ModelFactory.dart';

part 'models/racer.dart';
part 'models/RaceBracketDetail.dart';
part 'models/racepair.dart';
part 'models/RacePhase.dart';
part 'models/RaceStanding.dart';
part 'models/RaceBracket.dart';


//import 'package:json_object/json_object.dart';
//import 'package:dartson/dartson.dart';


enum ResultStatus { WIN, LOSE, TIE, INCOMPLETE }

 bool parseIsDeleted(var input){
  if(input !=null && input==1) return true;

  return false;
}

abstract class HasCarNumbers {
  List<int> getCarNumbers();
}


abstract class  HasRelational{
  Tuple2<String, List<dynamic>> generateSql();
  bool get isDeleted;
}

abstract class  HasJsonMap {
  Map toJson();
}

abstract class HasRaceMetaData
{

  RaceMetaData getRaceMetaData();
}
enum PhaseStatus { pending, complete, error }

class RaceMetaData{

  final PhaseStatus phaseStatus;
  final String raceUpdateTime;
  final String chartPosition;
  final String raceBracketName;

  RaceMetaData({this.raceBracketName,this.chartPosition,this.raceUpdateTime, this.phaseStatus});
}