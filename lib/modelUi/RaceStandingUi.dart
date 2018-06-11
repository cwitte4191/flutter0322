part of modelUi;

var tripleZero = new NumberFormat("000");

class RaceStandingUi implements DisplayableRace {
  final RaceStanding raceStanding;

  RaceStandingUi(RaceStanding raceStanding) : raceStanding = raceStanding;
  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    int overallWinningCar;
    if (raceStanding.phase1DeltaMS != null) {
      addResultTime(resultsSummary, "Phase A",
          raceStanding.phase1DeltaMS);
    }
    if (raceStanding.phase2DeltaMS != null) {
      addResultTime(resultsSummary, "Phase B",
          raceStanding.phase2DeltaMS);
      int overallMS = raceStanding.phase1DeltaMS + raceStanding.phase2DeltaMS;
      overallWinningCar = addResultTime(
          resultsSummary, "  Overall",  overallMS);
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
    return raceStanding.getRaceMetaData(bracketMap:globals.globalDerby.getRaceBrakcetCache());
  }

  int addResultTime(ResultsSummary resultsSummary, String phaseLiteral,
       int winningMS) {
    int car1=raceStanding.getCarNumbers()[0];
    int car2=raceStanding.getCarNumbers()[1];
    if (winningMS == 0) {
      resultsSummary.addMessage(car1, "$phaseLiteral: Tied");
      resultsSummary.addMessage(car2, "$phaseLiteral: Tied");
      return null;
    }
    int winningCar ;
    if (winningMS < 0) {
      winningCar = car2;
    }
    if (winningMS > 0) {
      winningCar = car1;
    }
    String formattedMS=tripleZero.format(winningMS.abs());
    resultsSummary.addMessage(
        winningCar, "$phaseLiteral: ${formattedMS}MS");
    return winningCar;
  }
}
