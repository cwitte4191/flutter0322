library modelUi;

import 'package:flutter/material.dart';
import 'package:flutter0322/models.dart';
import 'package:flutter0322/widgets/RaceResultWidget.dart';
import 'package:intl/intl.dart';
import 'package:flutter0322/globals.dart' as globals;

part 'modelUi/RaceBracketDetailUi.dart';
part 'modelUi/RacePhaseUi.dart';
part 'modelUi/RaceStandingUi.dart';


abstract class DisplayableRace implements HasCarNumbers, HasResultsSummary, HasRaceMetaData{}


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
