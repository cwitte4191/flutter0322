part of models;

class Racer {
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
    return {racerName: racerName, carNumber:carNumber};
  }

}