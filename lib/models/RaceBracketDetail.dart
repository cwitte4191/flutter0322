class RaceBracketDetail{
  String raceTitle;
  String templateName;
  var places=new Map<String,int> ();
  var heatDetailMap=new Map<String,HeatDetail>();

  Map<String,List<HeatDetail>> getHeatDetailByRound(){
    var rc=new Map<String,List<HeatDetail>> ();
    void iterateMapEntry(String key, HeatDetail heatDetail) {
      String round=heatDetail.raceDisposition.round;

      if (rc[round] ==null) rc[round]=new List<HeatDetail>();
      rc[round].add(heatDetail);
    }
    heatDetailMap.forEach(iterateMapEntry);
    return rc;
  }
  RaceBracketDetail.fromJsonMap(Map jsonMap){
    this.raceTitle=jsonMap["raceTitle"];
    this.templateName=jsonMap["templateName"];
    this.places=jsonMap["places"];
    var hd=jsonMap['heatDetailMap'];
    for(String key in hd.keys) {
      var value = hd[key];
      var rdMap = value["raceDisposition"];
      HeatDetail heatDetail=new HeatDetail();
      heatDetail.winner=value["winner"];
      heatDetail.heatKey=value["heatKey"];
      heatDetail.carNumber1=value["carNumber1"];
      heatDetail.carNumber2=value["carNumber2"];
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
class HeatDetail{
  int winner;
  String heatKey;
  RaceDisposition raceDisposition;
  int carNumber1;
  int carNumber2;
}
class RaceDisposition{
  String round;
  String race;
  String winDest;
  String loseDest;
}