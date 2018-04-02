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
      resultsSummary.addMessage(winner.carNumber, "Phase ${phase}: Tied");
      resultsSummary.addMessage(place2.carNumber, "Phase ${phase}: Tied");
    } else {
      resultsSummary.addMessage(
          winner.carNumber, "Phase ${phase}: ${winningMS}MS");
      resultsSummary.setIcon(winner.carNumber, RaceResultWidget.getFinishFlagWidget());
    }
  }

  @override
  List<int> getCarNumbers() {
    return raceEntries.keys.toList();
  }

  @override
  RaceMetaData getRaceMetaData() {
    return new RaceMetaData(raceUpdateTime: this.startMs.toString(),);
  }
}

class RaceEntry {
  int carNumber;
  int lane;
  int resultMS;
  int finishTtc;
  RaceEntry({this.carNumber, this.lane, this.resultMS, this.finishTtc});
}
