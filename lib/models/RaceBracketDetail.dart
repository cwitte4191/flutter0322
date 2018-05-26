part of models;

class RaceBracketDetail {
  final String raceTitle;
  final String templateName;
  final places = new SplayTreeMap<String, int>();
  final  heatDetailMap = new Map<String, HeatDetail>();

  RaceBracketDetail.fromJsonMap(Map jsonMap)
      : raceTitle = jsonMap["raceTitle"],
        templateName = jsonMap["templateName"] {
    for (String key in jsonMap["places"].keys) {
      places[key] = jsonMap["places"][key];
    }

    //this.places=jsonMap["places"];

    var hd = jsonMap['heatDetailMap'];
    for (String key in hd.keys) {
      var hdValue = hd[key];
      var rdMap = hdValue["raceDisposition"];
      HeatDetail heatDetail = new HeatDetail();
      heatDetail.winner = hdValue["winner"];
      heatDetail.heatKey = hdValue["heatKey"];
      heatDetail.carNumber1 = hdValue["carNumber1"];
      heatDetail.carNumber2 = hdValue["carNumber2"];
      this.heatDetailMap[key] = heatDetail;
      RaceDisposition raceDisposition = new RaceDisposition();
      raceDisposition.round = rdMap["round"];
      raceDisposition.race = rdMap["race"];
      raceDisposition.winDest = rdMap["winDest"];
      raceDisposition.loseDest = rdMap["loseDest"];

      heatDetail.raceDisposition = raceDisposition;
    }
  }

  void populateOriginKeys(){
    void keyPop(String heatKey, HeatDetail heatDetail){
      String winDestKey=RaceDisposition.getDestAsHeatDetailKey(heatDetail.raceDisposition?.winDest);
      String winDestSlot=RaceDisposition.getDestAsHeatDetailSlot(heatDetail.raceDisposition?.winDest);

      String loseDestKey=RaceDisposition.getDestAsHeatDetailKey(heatDetail.raceDisposition?.loseDest);
      String loseDestSlot=RaceDisposition.getDestAsHeatDetailSlot(heatDetail.raceDisposition?.loseDest);


      if( heatDetailMap.containsKey(winDestKey)){
        if(winDestSlot=="A") {
          heatDetailMap[winDestKey].originKeyCar1="Winner of ${heatDetail.toString()}";
        }
        else{
          heatDetailMap[winDestKey].originKeyCar2="Winner of ${heatDetail.toString()}";
        }
      }

      if( heatDetailMap.containsKey(loseDestKey)){
        if(loseDestSlot=="A") {
          heatDetailMap[loseDestKey].originKeyCar1="Loser of ${heatDetail.toString()}";
        }
        else{
          heatDetailMap[loseDestKey].originKeyCar2="Loser of ${heatDetail.toString()}";
        }
      }
    }
    heatDetailMap.forEach(keyPop);
  }

   String getRoundDescription(String heatKey){


    String trimmedKey=RaceDisposition.getDestAsHeatDetailKey(heatKey);
      if(heatDetailMap.containsKey(trimmedKey)){
        RaceDisposition rd=heatDetailMap[trimmedKey].raceDisposition;
        return "${rd.round}:$heatKey";
      }
      else{
        return heatKey;
      }
  }
}

class RaceDisposition {
  String round;
  String race;
  String winDest; // ex: 05A
  String loseDest;  // ex: 05B

 static String getDestAsHeatDetailKey(String heatKey){
    String trimmedKey=heatKey;
    trimmedKey=trimmedKey.replaceAll("A", "");
    trimmedKey=trimmedKey.replaceAll("B", "");
    return trimmedKey;
  }
  static String getDestAsHeatDetailSlot(String heatKey){

    if(heatKey.endsWith("A")) return "A";
    if(heatKey.endsWith("B")) return "B";
    return "";

  }
}

class HeatDetail {
  int winner;
  String heatKey;  //ex: 05
  RaceDisposition raceDisposition;
  int carNumber1;
  int carNumber2;
  String originKeyCar1;  //populated by scanning RaceDispositions.
  String originKeyCar2;

  @override
  List<int> getCarNumbers() {
    return [carNumber1, carNumber2];
  }
  String toString(){
    return "${raceDisposition.round}:$heatKey";
  }

}
