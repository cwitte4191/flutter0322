part of models;

class RacePhase {
  int id;
  final raceEntries = new Map<int, RaceEntry>();
  int loadMs;
  int lastUpdateMs;
  int startMs;
  int phaseNumber;
  int raceStandingID;

  String getPhaseLetter() {
    return phaseNumber == 1 ? "A" : "B";
  }

  RacePhase();
  RacePhase.fromJsonMap(Map jsonMap) {
    this.loadMs = jsonMap["loadMS"];
    this.lastUpdateMs = jsonMap["lastUpdateMS"];
    this.phaseNumber = jsonMap["phaseNumber"];
    this.raceStandingID = jsonMap["raceStandingID"];
    this.id = jsonMap["id"];
    int resultMS = jsonMap["resultMS"];
    marshallRaceEntryMap(resultMS, raceEntries,
        car1: jsonMap["carNumber1"], car2: jsonMap["carNumber2"]);
  }
  static void marshallRaceEntryMapFromRacePair(
      int resultMS, Map<int, RaceEntry> raceEntryMap, RacePair racePair) {
    marshallRaceEntryMap(resultMS, raceEntryMap,
        car1: racePair.car1, car2: racePair.car2);
  }

  static void marshallRaceEntryMap(
      int resultMS, Map<int, RaceEntry> raceEntryMap,
      {int car1, int car2}) {
    int lane1ResultMS = null;
    int lane2ResultMS = null;
    if (resultMS != null) {
      if (resultMS > 0) {
        lane1ResultMS = 0;
        lane2ResultMS = resultMS;
      } else {
        lane1ResultMS = resultMS.abs();
        lane2ResultMS = 0;
      }
    }

    raceEntryMap[car1] =
        new RaceEntry(carNumber: car1, lane: 1, resultMS: lane1ResultMS);
    raceEntryMap[car2] =
        new RaceEntry(carNumber: car2, lane: 2, resultMS: lane2ResultMS);
  }

  List<RaceEntry> getSortedRaceEntries() {
    return RaceEntry.getSortedRaceEntries(raceEntries);

  }

  addRaceEntry(RaceEntry raceEntry) {
    raceEntries[raceEntry.carNumber] = raceEntry;
  }

  List<int> getResultTimes(RaceEntry them) {
    return RaceEntry.getResultTimes(raceEntries, them);
  }

  List<RacePair> getRacePairs() {
    return RacePair.getRacePairs(raceEntries.keys.toList());
  }

  @override
  List<int> getCarNumbers() {
    return raceEntries.keys.toList();
  }

  @override
  RaceMetaData getRaceMetaData({Map<int,RaceBracket>bracketMap}) {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(this.loadMs, isUtc: true)
            .toLocal();
    var formattedDate = new DateFormat.Hms().format(date);
    // var dateString = format.format(date);
    return new RaceMetaData(
        raceUpdateTime: formattedDate, chartPosition: "Chart Placeholder");
  }
}

class RaceEntry {
  int carNumber;
  int lane;
  int resultMS;
  int finishTtc;
  RaceEntry({this.carNumber, this.lane, this.resultMS, this.finishTtc});
  static List<int> getResultTimes(Map<int,RaceEntry> raceEntries,RaceEntry them) {
    var rc = [];
    for (var raceEntry in raceEntries.values) {
      rc.add(them.resultMS - raceEntry.resultMS);
    }
    return rc;
  }
  static List<RaceEntry> getSortedRaceEntries(Map<int,RaceEntry> raceEntries) {
    var rc = raceEntries.values.toList();
    if (rc[0].resultMS == null || rc[1].resultMS == null) {
      return rc;
    }
    rc.sort((a, b) => a.resultMS.compareTo(b.resultMS));

    return rc;
  }
}
