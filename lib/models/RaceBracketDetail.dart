part of models;

//import '../models.dart';

class RaceBracketDetail{
  String raceTitle;
  String templateName;
  final places=new SplayTreeMap<String,int> ();
  var heatDetailMap=new Map<String,HeatDetail>();

  Map<String,List<DisplayableRace>> getDisplayableRaceByRound(){
    var rc=new Map<String,List<DisplayableRace>> ();
    void iterateMapEntry(String key, HeatDetail heatDetail) {
      String round=heatDetail.raceDisposition.round;

      if (rc[round] ==null) rc[round]=new List<HeatDetail>();
      rc[round].add(heatDetail);

    }
    heatDetailMap.forEach(iterateMapEntry);

    if(places !=null && places.length>0){
      rc["Places"]=new List<DisplayableRace>();
      for(String place in places.keys){
        print ("Place:"+place);
        print ("Place car:"+places[place].toString());
        //rc["Places"].add(new DisplayablePlace(place: place,carNumber: 044));
        rc["Places"].add(new DisplayablePlace(place: place,carNumber: places[place]));
      }
    }
    return rc;
  }
  RaceBracketDetail.fromJsonMap(Map jsonMap){
    this.raceTitle=jsonMap["raceTitle"];
    this.templateName=jsonMap["templateName"];

    for(String key in jsonMap["places"].keys){
      places[key]=jsonMap["places"][key];
    }



      //this.places=jsonMap["places"];

    var hd=jsonMap['heatDetailMap'];
    for(String key in hd.keys) {
      var hdValue = hd[key];
      var rdMap = hdValue["raceDisposition"];
      HeatDetail heatDetail=new HeatDetail();
      heatDetail.winner=hdValue["winner"];
      heatDetail.heatKey=hdValue["heatKey"];
      heatDetail.carNumber1=hdValue["carNumber1"];
      heatDetail.carNumber2=hdValue["carNumber2"];
      this.heatDetailMap[key]=heatDetail;
      RaceDisposition raceDisposition=new RaceDisposition();
      raceDisposition.round=rdMap["round"];
      raceDisposition.race=rdMap["race"];
      raceDisposition.winDest=rdMap["winDest"];
      raceDisposition.loseDest=rdMap["loseDest"];

      heatDetail.raceDisposition=raceDisposition;
    }
  }
}
class DisplayablePlace implements DisplayableRace{
  final String place;
  final int carNumber;
  DisplayablePlace({this.carNumber,this.place}):assert( carNumber!=null){

}

  @override
  List<int> getCarNumbers() {
    return new List<int>()
    ..add(this.carNumber);
  }

  @override
  RaceMetaData getRaceMetaData() {
    return new RaceMetaData(chartPosition: this.place);
  }

  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    return;
  }
}
class HeatDetail implements DisplayableRace{
  int winner;
  String heatKey;
  RaceDisposition raceDisposition;
  int carNumber1;
  int carNumber2;

  @override
  List<int> getCarNumbers() {
    return [carNumber1,carNumber2];
  }

  @override
  void getResultsSummary(ResultsSummary resultsSummary) {
    return;
  }



  @override
  RaceMetaData getRaceMetaData() {
    return new RaceMetaData(chartPosition: raceDisposition.round +":"+heatKey);
  }
}
class RaceDisposition{
  String round;
  String race;
  String winDest;
  String loseDest;
}