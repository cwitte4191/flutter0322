part of models;

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

  RacePhase() {}
  RacePhase.fromJsonMap(Map jsonMap) {
    this.loadMs = jsonMap["loadMS"];
    this.phaseNumber = jsonMap["phaseNumber"];
    this.raceStandingID = jsonMap["raceStandingID"];
    this.id = jsonMap["id"];
    int resultMS = jsonMap["resultMS"];
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
    raceEntries[jsonMap["carNumber1"]] = new RaceEntry(
        carNumber: jsonMap["carNumber1"], lane: 1, resultMS: lane1ResultMS);
    raceEntries[jsonMap["carNumber2"]] = new RaceEntry(
        carNumber: jsonMap["carNumber2"], lane: 2, resultMS: lane2ResultMS);
  }
  List<RaceEntry> getSortedRaceEntries() {
    var rc = raceEntries.values.toList();
    if (rc[0].resultMS == null || rc[1].resultMS == null) {
      return rc;
    }
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
    if (winner.resultMS == null) return;

    int winningMS = place2.resultMS - winner.resultMS;
    String phase = getPhaseLetter();
    if (winningMS == 0) {
      resultsSummary.addMessage(winner.carNumber, "Phase ${phase}: Tied");
      resultsSummary.addMessage(place2.carNumber, "Phase ${phase}: Tied");
    } else {
      resultsSummary.addMessage(
          winner.carNumber, "Phase ${phase}: ${winningMS}MS");
      resultsSummary.setIcon(
          winner.carNumber, RaceResultWidget.getFinishFlagWidget());
    }
  }

  @override
  List<int> getCarNumbers() {
    return raceEntries.keys.toList();
  }

  @override
  RaceMetaData getRaceMetaData() {
    return new RaceMetaData(
      raceUpdateTime: this.startMs.toString(),
    );
  }
}

class RaceEntry {
  int carNumber;
  int lane;
  int resultMS;
  int finishTtc;
  RaceEntry({this.carNumber, this.lane, this.resultMS, this.finishTtc});
}
