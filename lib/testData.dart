import 'dart:collection';
import 'dart:convert';

import 'package:flutter0322/models.dart';

class TestData{
  Map<int,Racer> getTestRacers(){
    var rc=new SplayTreeMap<int,Racer>();
    for(var x=0;x<1000;x++){
      rc[x]=new Racer()..carNumber=x..racerName=x.toString()+" "+x.toString()+":"+x.toString();
    }


    return rc;
  }

  String getRbdJson(){
    return '{"raceTitle":"sat pm ss","templateName":"single12","places":{"Place2":205,"Place1":203,"Place6":207,"Place5":202,"Place4":209,"Place3":206,"Place8":201,"Place7":210},"heatDetailMap":{"01":{"winner":207,"heatKey":"01","raceDisposition":{"round":"Left1","race":"01","winDest":"05A","loseDest":"OUT"},"carNumber1":207,"carNumber2":9011},"02":{"winner":203,"heatKey":"02","raceDisposition":{"round":"Left1","race":"02","winDest":"06A","loseDest":"OUT"},"carNumber1":203,"carNumber2":9021},"03":{"winner":202,"heatKey":"03","raceDisposition":{"round":"Left1","race":"03","winDest":"07A","loseDest":"OUT"},"carNumber1":202,"carNumber2":9031},"04":{"winner":206,"heatKey":"04","raceDisposition":{"round":"Left1","race":"04","winDest":"08A","loseDest":"OUT"},"carNumber1":206,"carNumber2":208},"05":{"winner":209,"heatKey":"05","raceDisposition":{"round":"Left2","race":"05","winDest":"09A","loseDest":"12A"},"carNumber1":207,"carNumber2":209},"06":{"winner":203,"heatKey":"06","raceDisposition":{"round":"Left2","race":"06","winDest":"09B","loseDest":"12B"},"carNumber1":203,"carNumber2":201},"07":{"winner":205,"heatKey":"07","raceDisposition":{"round":"Left2","race":"07","winDest":"10A","loseDest":"13A"},"carNumber1":202,"carNumber2":205},"08":{"winner":206,"heatKey":"08","raceDisposition":{"round":"Left2","race":"08","winDest":"10B","loseDest":"13B"},"carNumber1":206,"carNumber2":210},"09":{"winner":203,"heatKey":"09","raceDisposition":{"round":"Left3","race":"09","winDest":"11A","loseDest":"16A"},"carNumber1":209,"carNumber2":203},"10":{"winner":205,"heatKey":"10","raceDisposition":{"round":"Left3","race":"10","winDest":"11B","loseDest":"16B"},"carNumber1":205,"carNumber2":206},"11":{"winner":203,"heatKey":"11","raceDisposition":{"round":"Left4","race":"11","winDest":"Place1","loseDest":"Place2"},"carNumber1":203,"carNumber2":205},"12":{"winner":207,"heatKey":"12","raceDisposition":{"round":"Runoff","race":"12","winDest":"14A","loseDest":"15A"},"carNumber1":207,"carNumber2":201},"13":{"winner":202,"heatKey":"13","raceDisposition":{"round":"Runoff","race":"13","winDest":"14B","loseDest":"15B"},"carNumber1":202,"carNumber2":210},"14":{"winner":202,"heatKey":"14","raceDisposition":{"round":"Runoff","race":"14","winDest":"Place5","loseDest":"Place6"},"carNumber1":207,"carNumber2":202},"15":{"winner":210,"heatKey":"15","raceDisposition":{"round":"Runoff","race":"15","winDest":"Place7","loseDest":"Place8"},"carNumber1":201,"carNumber2":210},"16":{"winner":206,"heatKey":"16","raceDisposition":{"round":"Runoff","race":"16","winDest":"Place3","loseDest":"Place4"},"carNumber1":209,"carNumber2":206}},"seedPositions":["05B","06B","07B","08B","01A","02A","03A","04A","04B","02B","03B","01B"],"forfeitCars":{"209":"Mar 17, 2018 8:11:29 PM"}}';
  }

  String getRacePhaseJson(){
    return '{"type":"Persist","data":{"carNumber1":802,"carNumber2":801,"loadMS":1525527225916,"phaseNumber":2,"lastUpdateMS":1525527225936,"raceStandingID":1,"id":2,"version":1},"sn":"RacePhase"}';
  }
  RaceBracketDetail getRbd(){
    var rbd= JSON.decode(getRbdJson());
    print ("rbd: ${rbd}");
    print ("rbd heat detail: ${rbd['heatDetailMap']}");
    var hd=rbd['heatDetailMap'];
    for(String key in hd.keys){
      var value=hd[key];
      print ("rbd hd key: ${key} value: ${value}");

    }
    RaceBracketDetail raceBracketDetail=new RaceBracketDetail.fromJsonMap(rbd);
    print("rbd.places tostring:"+raceBracketDetail.places.toString());
    return raceBracketDetail;
  }
}