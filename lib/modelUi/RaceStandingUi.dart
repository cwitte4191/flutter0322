part of modelUi;

var tripleZero = new NumberFormat("000");

class RaceStandingUi implements DisplayableRace {
  final RaceStanding raceStanding;

  RaceStandingUi(RaceStanding raceStanding) : raceStanding = raceStanding;
  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    int overallWinningCar;
    if (raceStanding.phase1DeltaMS != null) {
      addResultTime(resultsSummary, "Phase A", raceStanding.racePair,
          raceStanding.phase1DeltaMS);
    }
    if (raceStanding.phase2DeltaMS != null) {
      addResultTime(resultsSummary, "Phase B", raceStanding.racePair,
          raceStanding.phase2DeltaMS);
      int overallMS = raceStanding.phase1DeltaMS + raceStanding.phase2DeltaMS;
      overallWinningCar = addResultTime(
          resultsSummary, "  Overall", raceStanding.racePair, overallMS);
    }

    if (overallWinningCar != null) {
      resultsSummary.setIcon(
          overallWinningCar, RaceResultWidget.getFinishFlagWidget());
    }
  }

  @override
  List<int> getCarNumbers() {
    return raceStanding.getCarNumbers();
  }

  @override
  RaceMetaData getRaceMetaData() {
    return raceStanding.getRaceMetaData(bracketMap:globals.globalDerby.bracketMap);
  }

  int addResultTime(ResultsSummary resultsSummary, String phaseLiteral,
      RacePair racePair, int winningMS) {
    if (winningMS == 0) {
      resultsSummary.addMessage(racePair.car1, "$phaseLiteral: Tied");
      resultsSummary.addMessage(racePair.car2, "$phaseLiteral: Tied");
      return null;
    }
    int winningCar = null;
    if (winningMS < 0) {
      winningCar = raceStanding.racePair.car2;
    }
    if (winningMS > 0) {
      winningCar = raceStanding.racePair.car1;
    }
    String formattedMS=tripleZero.format(winningMS.abs());
    resultsSummary.addMessage(
        winningCar, "$phaseLiteral: ${formattedMS}MS");
    return winningCar;
  }
}
