part of modelUi;

class RaceBracketDetailUi {
  final RaceBracketDetail raceBracketDetail;
  RaceBracketDetailUi(RaceBracketDetail raceBracketDetail)
      : raceBracketDetail = raceBracketDetail{
    raceBracketDetail.populateOriginKeys();
  }

  Map<String, List<DisplayableRace>> getDisplayableRaceByRound() {
    var rc = new Map<String, List<DisplayableRace>>();
    void iterateMapEntry(String key, HeatDetail heatDetail) {
      String round = heatDetail.raceDisposition.round;

      if (rc[round] == null) rc[round] = new List<HeatDetailUi>();
      rc[round].add(new HeatDetailUi(heatDetail, raceBracketDetail));
    }

    raceBracketDetail.heatDetailMap.forEach(iterateMapEntry);

    if (raceBracketDetail.places != null &&
        raceBracketDetail.places.length > 0) {
      rc["Places"] = new List<DisplayableRace>();
      for (String place in raceBracketDetail.places.keys) {
        print("Place:" + place);
        print("Place car:" + raceBracketDetail.places[place].toString());
        //rc["Places"].add(new DisplayablePlace(place: place,carNumber: 044));
        rc["Places"].add(new DisplayablePlace(
            place: place, carNumber: raceBracketDetail.places[place]));
      }
    }
    return rc;
  }
}

class DisplayablePlace implements DisplayableRace {
  final String place;
  final int carNumber;
  DisplayablePlace({this.carNumber, this.place}) : assert(carNumber != null);

  @override
  List<int> getCarNumbers() {
    return new List<int>()..add(this.carNumber);
  }

  @override
  RaceMetaData getRaceMetaData() {
    return new RaceMetaData(chartPosition: this.place);
  }

  static final RegExp regexNum = new RegExp(r"(\d+)");

  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    if (this.carNumber != null) {
      final Match placeIconText = regexNum.firstMatch(place);
      if (placeIconText != null) {
        resultsSummary.setIcon(
            this.carNumber,
            new Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Text(placeIconText.group(0),
                    textScaleFactor: 4.0,
                    style: new TextStyle(fontWeight: FontWeight.bold))));
      }
    }
    return;
  }
}

class HeatDetailUi implements DisplayableRace {
  final HeatDetail heatDetail;
  final RaceBracketDetail raceBracketDetail;
  HeatDetailUi(HeatDetail heatDetail, RaceBracketDetail raceBracketDetail)
      : heatDetail = heatDetail,
        raceBracketDetail = raceBracketDetail;

  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    if (heatDetail.winner != null) {
      return getCompletedResultsSummary(resultsSummary);
    } else {
      return getPendingResultsSummary(resultsSummary);
    }
  }

  void getPendingResultsSummary(ResultsSummary resultsSummary) {

    String origin1=heatDetail.originKeyCar1;
    String origin2=heatDetail.originKeyCar2;
    origin1=(origin1==null)?"Seed":origin1;
    origin2=(origin2==null)?"Seed":origin2;
    resultsSummary.addMessage(null, "$origin1 vs. $origin2");
  }

  void getCompletedResultsSummary(ResultsSummary resultsSummary) {
    resultsSummary.setIcon(
        heatDetail.winner, RaceResultWidget.getFinishFlagWidget());

    String roundDescription = raceBracketDetail
        .getRoundDescription(heatDetail.raceDisposition.winDest);

    resultsSummary.addMessage(heatDetail.winner, "To: $roundDescription");

    int loser;
    for (int carNumber in getCarNumbers()) {
      if (carNumber != heatDetail.winner) {
        loser = carNumber;
      }
    }
    if (loser != null) {
      String roundDescription = raceBracketDetail
          .getRoundDescription(heatDetail.raceDisposition.loseDest);

      resultsSummary.addMessage(loser, "To: $roundDescription");
    }
    return;
  }

  @override
  RaceMetaData getRaceMetaData() {
    return new RaceMetaData(
        chartPosition:
            heatDetail.raceDisposition.round + ":" + heatDetail.heatKey);
  }

  @override
  List<int> getCarNumbers() {
    List<int> hdCars = heatDetail.getCarNumbers();

    if (hdCars == null) {
      hdCars = [-2, -2];
    }
    if (hdCars != null) {
      if (hdCars[0] == null) hdCars[0] = -1;
      if (hdCars[1] == null) hdCars[1] = -2;
    }

    return hdCars;
    //return heatDetail.getCarNumbers();
  }
}
