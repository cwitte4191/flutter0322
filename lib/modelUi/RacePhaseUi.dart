
part of modelUi;


class RacePhaseUi implements DisplayableRace {
  var tripleZero = new NumberFormat("000");

  final RacePhase racePhase;
  RacePhaseUi(RacePhase racePhase):racePhase=racePhase ;


  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    var sortedEntries = racePhase.getSortedRaceEntries();
    RaceEntry winner = sortedEntries[0];
    RaceEntry place2 = sortedEntries[1];
    if (winner.resultMS == null) return;

    int winningMS = place2.resultMS - winner.resultMS;
    String phase = racePhase.getPhaseLetter();
    if (winningMS == 0) {
      resultsSummary.addMessage(winner.carNumber, "Phase $phase: Tied");
      resultsSummary.addMessage(place2.carNumber, "Phase $phase: Tied");
    } else {
      String formattedWinningMS=tripleZero.format(winningMS);
      resultsSummary.addMessage(
          winner.carNumber, "Phase $phase: ${formattedWinningMS}MS");
      resultsSummary.setIcon(
          winner.carNumber, RaceResultWidget.getFinishFlagWidget());
    }
  }

  @override
  List<int> getCarNumbers() {
    return racePhase.getCarNumbers();
  }

  @override
  RaceMetaData getRaceMetaData() {
    return racePhase.getRaceMetaData();
  }
}