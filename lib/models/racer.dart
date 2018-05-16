part of models;

class Racer implements HasJsonMap {
  String racerName;
  int carNumber;

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
  Map toJson(){
    return {"racerName": racerName, "carNumber":carNumber};
  }
  Racer();

  Racer.fromJsonMap(Map jsonMap){
    this.racerName = jsonMap["firstName"];
    this.carNumber = jsonMap["carNumber"];
  }
}