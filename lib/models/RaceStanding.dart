part of models;
class RaceStanding {
  int id;
  String chartPosition;
  int raceBracketID;
  int lastUpdateMS;
  final phase1Entries = new Map<int, RaceEntry>();
  final phase2Entries = new Map<int, RaceEntry>();

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
    RacePhase.marshallRaceEntryMap(phase1DeltaMS,phase1Entries, car1: jsonMap["carNumber1"],car2:jsonMap["carNumber2"]);
    RacePhase.marshallRaceEntryMap(phase2DeltaMS,phase2Entries, car1: jsonMap["carNumber1"],car2:jsonMap["carNumber2"]);

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

}