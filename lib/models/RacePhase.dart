part of models;

class RacePhase implements HasJsonMap, HasCarNumbers, HasRaceMetaData, HasRelational {
  int id;
  final raceEntryList = new List<RaceEntry>();
  int loadMs;
  int lastUpdateMs;
  int startMs;
  int phaseNumber;
  int raceStandingID;
  bool isDeleted;

  String getPhaseLetter() {
    return phaseNumber == 1 ? "A" : "B";
  }

  RacePhase();
  RacePhase.fromSqlMap(Map jsonMap) {
    initFromMap(jsonMap);
  }
  RacePhase.fromJsonMap(Map jsonMap) {
    initFromMap(jsonMap);
  }
  void initFromMap(Map jsonMap) {
    this.loadMs = jsonMap["loadMS"];
    this.lastUpdateMs = jsonMap["lastUpdateMS"];
    this.phaseNumber = jsonMap["phaseNumber"];
    this.raceStandingID = jsonMap["raceStandingID"];
    this.id = jsonMap["id"];
    int resultMS = jsonMap["resultMS"];
    marshallRaceEntryList(resultMS, raceEntryList,
        car1: jsonMap["carNumber1"], car2: jsonMap["carNumber2"]);

    this.isDeleted=parseIsDeleted(jsonMap["isDeleted"]);

  }

  static void marshallRaceEntryList(int resultMS, List<RaceEntry> raceEntryList,
      {car1, car2}) {
    int lane1ResultMS;
    int lane2ResultMS;
    if (resultMS != null) {
      if (resultMS > 0) {
        lane1ResultMS = 0;
        lane2ResultMS = resultMS;
      } else {
        lane1ResultMS = resultMS.abs();
        lane2ResultMS = 0;
      }
    }

    raceEntryList.clear();

    raceEntryList
        .add(new RaceEntry(carNumber: car1, lane: 1, resultMS: lane1ResultMS));
    raceEntryList
        .add(new RaceEntry(carNumber: car2, lane: 2, resultMS: lane2ResultMS));
  }

  static void marshallRaceEntryListFromRacePair(
      int resultMS, List<RaceEntry> raceEntryList, RacePair racePair) {
    marshallRaceEntryList(resultMS, raceEntryList,
        car1: racePair.car1, car2: racePair.car2);
  }

  @override
  Map toJson() {
    int car1 = raceEntryList[0].carNumber;
    int car2 = raceEntryList[1].carNumber;

    return {
      "id": id,
      "raceStandingID": raceStandingID,
      "phaseNumber": phaseNumber,
      "startMs": startMs,
      "lastUpdateMs": lastUpdateMs,
      "loadMs": loadMs,
      "carNumber1": car1,
      "carNumber2": car2
    };
  }

  List<RaceEntry> getSortedRaceEntries() {
    return RaceEntry.getSortedRaceEntries(raceEntryList);
  }

  addRaceEntry(RaceEntry raceEntry) {
    raceEntryList.add(raceEntry);
  }

  List<int> getResultTimes(RaceEntry them) {
    return RaceEntry.getResultTimes(raceEntryList, them);
  }

  @override
  List<int> getCarNumbers() {
    return RaceEntry.getCarNumbers(this.raceEntryList);
  }

  int getCompatResultMs() {
    var sortedEntries = this.getSortedRaceEntries();
    RaceEntry winner = sortedEntries[0];
    RaceEntry place2 = sortedEntries[1];
    if (winner.resultMS == null) return null;

    int winningMS = place2.resultMS - winner.resultMS;
    return winningMS;
  }

  PhaseStatus getPhaseStatus() {
    if (this.raceStandingID == null) {
      return PhaseStatus.error;
    }
    for (var raceEntry in raceEntryList) {
      if (raceEntry.resultMS != null) {
        return PhaseStatus.complete;
      }
    }
    return PhaseStatus.pending;
  }

  @override
  RaceMetaData getRaceMetaData({Map<int, RaceBracket> bracketMap}) {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(this.loadMs, isUtc: true)
            .toLocal();
    var formattedDate = new DateFormat.Hms().format(date);
    // var dateString = format.format(date);

    return new RaceMetaData(
        raceUpdateTime: formattedDate,
        chartPosition: "Chart Placeholder",
        phaseStatus: getPhaseStatus());
  }

  static String selectSql =
      "select * from RacePhase where isDeleted=0 order by id desc";
  static const String insertSql =
      "REPLACE INTO RacePhase(id, raceStandingID, phaseNumber, carNumber1, carNumber2,  resultMS, loadMS, lastUpdateMS, isDeleted) VALUES(?,?,?,?,?,?,?,?,?)";
  static const String createSql =
      "CREATE TABLE RacePhase(id INTEGER PRIMARY KEY, raceStandingID Integer, phaseNumber integer, carNumber1 integer, carNumber2 integer, resultMS integer, loadMS integer, lastUpdateMS integer ,  isDeleted INTEGER) ";


  Tuple2<String, List<dynamic>> generateSql() {
    return new Tuple2(insertSql, [
      //
      this.id, //
      this.raceStandingID, //
      this.phaseNumber, //
      this.raceEntryList[0].carNumber, //
      this.raceEntryList[1].carNumber, //
      getCompatResultMs(), //
      this.loadMs,
      this.lastUpdateMs,
      ModelFactory.boolAsInt(isDeleted)

    ]);
  }

  static String getCreateSql() {
    return createSql;
  }

  static String getSelectSql() {
    return selectSql;
  }
}

class RaceEntry {
  int carNumber;
  int lane;
  int resultMS;
  int finishTtc;
  RaceEntry({this.carNumber, this.lane, this.resultMS, this.finishTtc});
  static List<int> getResultTimes(
      List<RaceEntry> raceEntryList, RaceEntry them) {
    var rc = [];
    for (var raceEntry in raceEntryList) {
      rc.add(them.resultMS - raceEntry.resultMS);
    }
    return rc;
  }

  static List<RaceEntry> getSortedRaceEntries(List<RaceEntry> raceEntryList) {
    var rc = raceEntryList.toList();
    if (rc[0].resultMS == null || rc[1].resultMS == null) {
      return rc;
    }
    rc.sort((a, b) => a.resultMS.compareTo(b.resultMS));

    return rc;
  }

  static List<int> getCarNumbers(List<RaceEntry> raceEntryList) {
    List<int> rc = [];
    for (RaceEntry raceEntry in raceEntryList) {
      rc.add(raceEntry.carNumber);
    }
    return rc;
  }

  Map toJson() {
    return {
      "carNumber": carNumber,
      "lane": lane,
      "resultMS": resultMS,
      "finishTtc": finishTtc
    };
  }
}
