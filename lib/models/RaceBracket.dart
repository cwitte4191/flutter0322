part of models;

class RaceBracket {
  int id;
String raceName;
String raceStatus;
String jsonDetail;
  RaceBracket.fromJsonMap(Map jsonMap) {
    this.raceName = jsonMap["raceName"];
    this.raceStatus = jsonMap["raceStatus"];
    this.jsonDetail = jsonMap["json"];
    this.id = jsonMap["id"];
  }

  Tuple2<String, List> generateSql(int isDeleted) {
    return null;
  }
}