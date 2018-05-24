part of models;

class RaceStanding implements HasRelational, HasCarNumbers{
  int id;
  String chartPosition;
  int raceBracketID;
  int lastUpdateMS;
  final phase1EntryList = new List<RaceEntry>();
  final phase2EntryList = new List<RaceEntry>();

  int phase1DeltaMS; // planning transition to raceEntries
  int phase2DeltaMS; // planning transition
  RacePair racePair;
  bool isDeleted;

  RaceStanding({car1: int, car2: int}) : racePair = new RacePair(car1, car2);

  RaceStanding.fromSqlMap(Map jsonMap) {
    initFromMap(jsonMap);
  }
  RaceStanding.fromJsonMap(Map jsonMap) {
    initFromMap(jsonMap);
  }
  initFromMap(Map jsonMap) {
    this.chartPosition = jsonMap["chartPosition"];
    this.raceBracketID = jsonMap["raceBracketID"];
    this.lastUpdateMS = jsonMap["lastUpdateMS"];
    this.id = jsonMap["id"];
    phase1DeltaMS = jsonMap["phase1DeltaMS"];
    phase2DeltaMS = jsonMap["phase2DeltaMS"];

    racePair = new RacePair(jsonMap["carNumber1"], jsonMap["carNumber2"]);
    RacePhase.marshallRaceEntryList(phase1DeltaMS, phase1EntryList,
        car1: jsonMap["carNumber1"], car2: jsonMap["carNumber2"]);
    RacePhase.marshallRaceEntryList(phase2DeltaMS, phase2EntryList,
        car1: jsonMap["carNumber1"], car2: jsonMap["carNumber2"]);


    this.isDeleted=parseIsDeleted(jsonMap["isDeleted"]);
  }

  @override
  List<int> getCarNumbers() {
    return []..add(racePair.car1)..add(racePair.car2);
  }

  RaceMetaData getRaceMetaData({Map<int, RaceBracket> bracketMap}) {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(this.lastUpdateMS, isUtc: true)
            .toLocal();
    var formattedDate = new DateFormat.Hms().format(date);
    String bracketName ;
    if (bracketMap != null) {
      bracketName = bracketMap[raceBracketID]?.raceName;
    }
    return new RaceMetaData(
        chartPosition: this.chartPosition,
        raceUpdateTime: formattedDate,
        raceBracketName: bracketName);
  }

  static bool isPending(RaceStanding rs) {
    return rs.phase2DeltaMS == null;
  }

  static bool isNotPending(RaceStanding rs) {
    return !isPending(rs);
  }



  static String selectSql =
      "select * from RaceStanding where isDeleted=0 and isPending=0 order by lastUpdateMS desc";
  static String selectPendingSql =
      "select * from RaceStanding where isDeleted=0 and isPending > 0 order by lastUpdateMS desc";
  static const String insertSql =
      "REPLACE INTO RaceStanding(id, chartPosition, raceBracketID, carNumber1, carNumber2,  phase1DeltaMS, phase2DeltaMS, lastUpdateMS, isPending, isDeleted) VALUES(?,?,?, ?,?,?, ?,?,?, ?)";
  static const String createSql =
      "CREATE TABLE RaceStanding(id INTEGER PRIMARY KEY, chartPosition TEXT, raceBracketID Integer, carNumber1 integer, carNumber2 integer, phase1DeltaMS integer, phase2DeltaMS integer, lastUpdateMS integer ,  isPending INTEGER, isDeleted INTEGER) ";

  Tuple2<String, List<dynamic>> generateSql() {
    return new Tuple2(insertSql, [
      //
      this.id, //
      this.chartPosition, //
      this.raceBracketID, //
      this.phase1EntryList[0].carNumber, //
      this.phase1EntryList[1].carNumber, //
      this.phase1DeltaMS, //
      this.phase2DeltaMS,
      this.lastUpdateMS,
      ModelFactory.boolAsInt(isPending(this)),
      ModelFactory.boolAsInt(isDeleted)
    ]);
  }

  static String getCreateSql() {
    return createSql;
  }

  static String getSelectSql(bool getPending) {
    return getPending ? selectPendingSql : selectSql;
  }
}
