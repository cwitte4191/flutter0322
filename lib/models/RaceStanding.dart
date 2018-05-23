part of models;
class RaceStanding {
  int id;
  String chartPosition;
  int raceBracketID;
  int lastUpdateMS;
  final phase1EntryList = new List< RaceEntry>();
  final phase2EntryList = new List< RaceEntry>();

  int phase1DeltaMS; // planning transition to raceEntries
  int phase2DeltaMS; // planning transition
  RacePair racePair;

  RaceStanding({car1: int, car2: int }):
        racePair=new RacePair(car1,car2);


  RaceStanding.fromJsonMap(Map jsonMap) {
    this.chartPosition=jsonMap["chartPosition"];
    this.raceBracketID=jsonMap["raceBracketID"];
    this.lastUpdateMS = jsonMap["lastUpdateMS"];
    this.id = jsonMap["id"];
    phase1DeltaMS = jsonMap["phase1DeltaMS"];
    phase2DeltaMS = jsonMap["phase2DeltaMS"];

    racePair=new RacePair(jsonMap["carNumber1"], jsonMap["carNumber2"]);
    RacePhase.marshallRaceEntryList(phase1DeltaMS,phase1EntryList, car1: jsonMap["carNumber1"],car2:jsonMap["carNumber2"]);
    RacePhase.marshallRaceEntryList(phase2DeltaMS,phase2EntryList, car1: jsonMap["carNumber1"],car2:jsonMap["carNumber2"]);

  }
  @override
  List<int> getCarNumbers() {
    return []..add(racePair.car1)..add(racePair.car2);
  }

  RaceMetaData getRaceMetaData({Map<int,RaceBracket>bracketMap}) {

    DateTime date =
    new DateTime.fromMillisecondsSinceEpoch(this.lastUpdateMS, isUtc: true)
        .toLocal();
    var formattedDate = new DateFormat.Hms().format(date);
    String bracketName=null;
    if(bracketMap!=null){
      bracketName=bracketMap[raceBracketID]?.raceName;
    }
    return new RaceMetaData(chartPosition: this.chartPosition, raceUpdateTime: formattedDate,raceBracketName: bracketName);
  }

  static bool isPending(RaceStanding rs){
    return rs.phase2DeltaMS==null;
  }
  static bool isNotPending(RaceStanding rs){
    return ! isPending(rs);
  }

  Tuple2<String, List> generateSql(int isDeleted) {
return null;
  }
}