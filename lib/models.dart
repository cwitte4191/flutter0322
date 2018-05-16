library models;
import 'dart:math';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'models/racer.dart';
part 'models/RaceBracketDetail.dart';
part 'models/racepair.dart';
part 'models/RacePhase.dart';
part 'models/RaceStanding.dart';
part 'models/RaceBracket.dart';


//import 'package:json_object/json_object.dart';
//import 'package:dartson/dartson.dart';


enum ResultStatus { WIN, LOSE, TIE, INCOMPLETE }



abstract class HasCarNumbers {
  List<int> getCarNumbers();
}




abstract class  HasJsonMap {

}

abstract class HasRaceMetaData
{

  RaceMetaData getRaceMetaData();
}
class RaceMetaData{

  final String raceUpdateTime;
  final String chartPosition;
  final String raceBracketName;
  RaceMetaData({this.raceBracketName,this.chartPosition,this.raceUpdateTime});
}