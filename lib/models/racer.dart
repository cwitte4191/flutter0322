part of models;

class Racer implements HasJsonMap, HasRelational {
  String racerName;
  int carNumber;

  bool isDeleted;
  @override
  int get hashCode {
    return carNumber.hashCode;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! Racer) return false;
    Racer racer = other;
    return carNumber == racer.carNumber;
  }

  @override
  Map toJson() {
    return {"racerName": racerName, "carNumber": carNumber};
  }

  Racer({this.racerName, this.carNumber});

  Racer.fromSqlMap(Map rawMap) {
    initFromMap(rawMap);
  }

  Racer.fromJsonMap(Map jsonMap) {
    initFromMap(jsonMap);
  }
  initFromMap(Map jsonMap) {

    this.racerName = jsonMap["firstName"] != null
        ? jsonMap["firstName"]
        : jsonMap["racerName"];

    this.carNumber = jsonMap["carNumber"];
    this.isDeleted = parseIsDeleted(jsonMap["isDeleted"]);
  }

  static String selectSql =
      "select * from Racer where isDeleted=0 order by carNumber";
  static const String insertSql =
      "REPLACE INTO Racer(carNumber, racerName, isDeleted) VALUES(?,?,?)";
  static const String createSql =
      "CREATE TABLE Racer(carNumber INTEGER PRIMARY KEY, racerName TEXT, isDeleted INTEGER) ";
  Tuple2<String, List<dynamic>> generateSql() {
    return new Tuple2(insertSql,
        [this.carNumber, this.racerName, ModelFactory.boolAsInt(isDeleted)]);
  }

  static String getCreateSql() {
    return createSql;
  }

  static String getSelectSql() {
    return selectSql;
  }
}
