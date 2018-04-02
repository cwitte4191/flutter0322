library models;
import 'dart:math';
import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';

import 'widgets/RaceResultWidget.dart';

part 'models/racer.dart';
part 'models/RaceBracketDetail.dart';
part 'models/racepair.dart';
part 'models/RacePhase.dart';
part 'models/RaceStanding.dart';


//import 'package:json_object/json_object.dart';
//import 'package:dartson/dartson.dart';


enum ResultStatus { WIN, LOSE, TIE, INCOMPLETE }



abstract class HasCarNumbers {
  List<int> getCarNumbers();
}

abstract class HasResultsSummary {
  //void getResultsSummary(Map<RaceEntry,String> resultsSummary);
  void getResultsSummary(ResultsSummary resultsSummary);
}
class ResultsSummary{
  var _summaryMap=new Map<int, List<String>>();

  var _iconMap=new Map<int,Widget>();

  void addMessage(int carNumber, String message){
    _summaryMap.putIfAbsent(carNumber, ()=>[]);
    _summaryMap[carNumber].add(message);
  }
  void setIcon(int carNumber, Widget icon){
    _iconMap[carNumber]=icon;
  }
  List<String> getMessages(int carNumber){
    _summaryMap.putIfAbsent(carNumber, ()=>[]);
    return _summaryMap[carNumber];
  }
  Widget getIcon(int carNumber){
    return _iconMap[carNumber];
  }
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
abstract class DisplayableRace implements HasCarNumbers, HasResultsSummary, HasRaceMetaData{}







