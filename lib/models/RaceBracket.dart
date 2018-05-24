part of models;

class RaceBracket implements HasRelational {
  int id;
  String raceName;
  String raceStatus;
  String jsonDetail;
  bool isDeleted;

  RaceBracket.fromSqlMap(Map rawMap) {
    initFromMap(rawMap);
  }

  RaceBracket.fromJsonMap(Map jsonMap) {
    initFromMap(jsonMap);
  }

  initFromMap(Map jsonMap) {
    this.raceName = jsonMap["raceName"];
    this.raceStatus = jsonMap["raceStatus"];
    // json from server, jsonDetail from local sqlite
    this.jsonDetail = jsonMap["json"]!=null?jsonMap["json"]:jsonMap["jsonDetail"];
    this.id = jsonMap["id"];
    this.isDeleted = parseIsDeleted(jsonMap["isDeleted"]);
  }



  static String selectSql =
      "select * from RaceBracket where isDeleted=0 order by raceName";
  static const String insertSql =
      "REPLACE INTO RaceBracket(id, raceName, raceStatus, jsonDetail, isDeleted) VALUES(?,?,?,  ?,?)";
  static const String createSql =
      "CREATE TABLE RaceBracket(id INTEGER PRIMARY KEY, raceName TEXT, raceStatus TEXT, jsonDetail TEXT, isDeleted INTEGER) ";
  Tuple2<String, List<dynamic>> generateSql() {
    return new Tuple2(insertSql, [
      this.id,
      this.raceName,
      this.raceStatus,
      this.jsonDetail,
      ModelFactory.boolAsInt(isDeleted)
    ]);
  }

  static String getCreateSql() {
    return createSql;
  }

  static String getSelectSql() {
    return selectSql;
  }
}
