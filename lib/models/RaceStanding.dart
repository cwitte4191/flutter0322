part of models;

class RaceStanding implements HasRelational, HasCarNumbers{
  int id;
  String chartPosition;
  int raceBracketID;
  int lastUpdateMS;
  final phase1EntryList = new List<RaceEntry>();
  final phase2EntryList = new List<RaceEntry>();

  // compat storage for 2 car race.
  final List<int> carNumbers=[];
  int phase1DeltaMS; // planning transition to raceEntries
  int phase2DeltaMS; // planning transition
  bool isDeleted;


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

    RacePhase.marshallRaceEntryList(phase1DeltaMS, phase1EntryList,
        car1: jsonMap["carNumber1"], car2: jsonMap["carNumber2"]);
    RacePhase.marshallRaceEntryList(phase2DeltaMS, phase2EntryList,
        car1: jsonMap["carNumber1"], car2: jsonMap["carNumber2"]);

    carNumbers.clear();
    carNumbers.add(0);  // prime the array with 2 carnumbers to avoid range error
    carNumbers.add(0);
    carNumbers[0]=jsonMap["carNumber1"];
    carNumbers[1]=jsonMap["carNumber2"];

    this.isDeleted=parseIsDeleted(jsonMap["isDeleted"]);
  }

  @override
  List<int> getCarNumbers() {
    return carNumbers;
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


  //
  static bool isPending(RaceStanding rs) {
    return rs.phase2DeltaMS == null || rs.phase2DeltaMS==null;;
  }





  static String selectSql =
      "select * from RaceStanding where isDeleted=0 {carFilter} order by lastUpdateMS desc";
  static String selectPendingSql =
      "select * from RaceStanding where isDeleted=0 and isPending > 0  {carFilter} order by lastUpdateMS desc";
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

  static String getSelectSql({String carFilter,bool getPending}) {
    String sqlFilter=RacePhase.transformFiltertoSql(carFilter);
    String pendgingSql= getPending ? selectPendingSql : selectSql;

    return pendgingSql.replaceAll("{carFilter}", sqlFilter);
  }

}
