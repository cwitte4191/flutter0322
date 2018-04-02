part of models;
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
    if (overallMS == 0) {
      resultsSummary.addMessage(racePair.car1,"Overall: Tied");
      resultsSummary.addMessage(racePair.car2,"Overall: Tied");
    }
    int winningCar=null;
    if (overallMS < 0) {
      winningCar=racePair.car2;
    }
    if (overallMS > 0) {
      winningCar=racePair.car1;
    }
    resultsSummary.addMessage(winningCar,"Overall: ${overallMS.abs()}MS");
    resultsSummary.setIcon(winningCar,RaceResultWidget.getFinishFlagWidget());



  }

  @override
  List<int> getCarNumbers() {
    return []..add(racePair.car1)..add(racePair.car2);
  }

  @override
  RaceMetaData getRaceMetaData() {
    return new RaceMetaData(chartPosition: this.chartPosition,);
  }


}