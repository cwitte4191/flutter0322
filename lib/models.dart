import 'dart:math';
import 'dart:convert';
import 'models/racepair.dart';
//import 'package:json_object/json_object.dart';
//import 'package:dartson/dartson.dart';

class RaceEntry {
  int carNumber;
  int lane;
  int resultMS;
  int finishTtc;
  RaceEntry({this.carNumber, this.lane, this.resultMS, this.finishTtc});
}

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

  void addMessage(int carNumber, String message){
    _summaryMap.putIfAbsent(carNumber, ()=>[]);
    _summaryMap[carNumber].add(message);
  }
  List<String> getMessages(int carNumber){
    _summaryMap.putIfAbsent(carNumber, ()=>[]);
    return _summaryMap[carNumber];
  }
}

abstract class DisplayableRace implements HasCarNumbers, HasResultsSummary {}

class RaceStanding implements DisplayableRace {
  int id;
  String chartPosition;
  int raceBracketID;
  int phase1DeltaMS;
  int phase2DeleaMS;
  RacePair racePair;

  RaceStanding({car1: int, car2: int }):
      racePair=new RacePair(car1,car2)
  {

  }
  @override
  void getResultsSummary(ResultsSummary resultsSummary) {

    if (phase2DeleaMS == null) return;
    int overallMS = phase1DeltaMS + phase2DeleaMS;
    if (overallMS < 0) {
      resultsSummary.addMessage(racePair.car2,"Overall: ${overallMS}MS");
    }
    if (overallMS > 0) {
      resultsSummary.addMessage(racePair.car1,"Overall: ${overallMS}MS");
    }

    if (overallMS == 0) {
      resultsSummary.addMessage(racePair.car1,"Overall: Tied");
      resultsSummary.addMessage(racePair.car2,"Overall: Tied");
    }
  }

  @override
  List<int> getCarNumbers() {
    return []..add(racePair.car1)..add(racePair.car2);
  }
}

class RacePhase implements DisplayableRace {
  int id;
  final raceEntries = new Map<int, RaceEntry>();
  int loadMs;
  int startMs;
  int phaseNumber;
  int raceStandingID;

  String getPhaseLetter() {
    return phaseNumber == 1 ? "A" : "B";
  }

  List<RaceEntry> getSortedRaceEntries() {
    var rc = raceEntries.values.toList();

    rc.sort((a, b) => a.resultMS.compareTo(b.resultMS));

    return rc;
  }

  addRaceEntry(RaceEntry raceEntry) {
    raceEntries[raceEntry.carNumber] = raceEntry;
  }

  List<int> getResultTimes(RaceEntry them) {
    var rc = [];
    for (var raceEntry in raceEntries.values) {
      rc.add(them.resultMS - raceEntry.resultMS);
    }
    return rc;
  }

  List<RacePair> getRacePairs() {
    return RacePair.getRacePairs(raceEntries.keys.toList());
  }

  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    var sortedEntries = getSortedRaceEntries();
    RaceEntry winner = sortedEntries[0];
    RaceEntry place2 = sortedEntries[1];
    int winningMS = place2.resultMS - winner.resultMS;
    String phase = getPhaseLetter();
    if (winningMS == 0) {
      resultsSummary.addMessage(winner.carNumber,"Phase ${phase}: Tied");
      resultsSummary.addMessage(place2.carNumber,"Phase ${phase}: Tied");
    } else {
      resultsSummary.addMessage(winner.carNumber,"Phase ${phase}: ${winningMS}MS");
    }
  }

  @override
  List<int> getCarNumbers() {
    return raceEntries.keys.toList();
  }
}
