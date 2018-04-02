//import 'dart:math';
//import 'dart:convert';
part of models;
class RacePair {
  final String key;
  final int car1;
  final int car2;
  RacePair._internal(this.car1, this.car2)
      : key = "${car1}.${car2}",
        assert(car1 != car2){
    var mapp=[{"1":1,"2":2,"3":3}];
    print("mapp: ${mapp}");
    String json=JSON.encode(this);
    print("json: ${json}");
    var foo=JSON.decode(json);
    print ("decode: ${foo.toString()}");
    print ("decode  type: ${foo.runtimeType.toString()}");
    //print ("decode  type: ${foo[0].runtimeType.toString()}");
    int c=foo['car1'];
    print ("foo car1: ${c}");
    //var data = new JsonObject.fromJsonString(json);
    //print("decode2: ${data[car1]}");

  }

  factory RacePair(int c1, int c2) {
    return new RacePair._internal(min(c1, c2), max(c1, c2));
  }
  @override
  int get hashCode {
    return key.hashCode;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! RacePair) return false;
    RacePair racePair = other;
    return key == racePair.key;
  }

  static List<RacePair> getRacePairs(List<int> carNumbers) {
    var rc = [];

    for (int i = 0; i < carNumbers.length; i++) {
      for (int j = i + 1; j < carNumbers.length; j++) {
        rc.add(new RacePair(carNumbers[i], carNumbers[j]));
      }
    }
    return rc;
  }

  @override
  Map toJson(){
    return {"car1":car1, "car2":car2};
  }

}

abstract class HasRacePairs {
  List<RacePair> getRacePairs();
}