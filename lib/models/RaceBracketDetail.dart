part of models;


class RaceBracketDetail{
  String raceTitle;
  String templateName;
  final places=new SplayTreeMap<String,int> ();
  var heatDetailMap=new Map<String,HeatDetail>();


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
class RaceDisposition{
  String round;
  String race;
  String winDest;
  String loseDest;
}
class HeatDetail {
  int winner;
  String heatKey;
  RaceDisposition raceDisposition;
  int carNumber1;
  int carNumber2;

  @override
  List<int> getCarNumbers() {
    return [carNumber1,carNumber2];
  }


}
