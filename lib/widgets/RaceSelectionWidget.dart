import 'package:flutter/material.dart';
import '../appPages/RaceSelection2.dart';
import '../models.dart';
import '../network/GetS3Object.dart';

class RaceSelectionWidget extends StatelessWidget {
  final double f1 = 1.8;
  final String displayFile;
  final String fullPath;
  final Color bgColor;
  RaceSelectionWidget({Key, key, this.displayFile, this.fullPath, this.bgColor})
      : assert(displayFile != null),
        assert(fullPath != null),
        super(key: key) {}
  @override
  Widget build(BuildContext context) {
    String truncateDf = displayFile;
    truncateDf = truncateDf.replaceAll(new RegExp(r".xml"), "");
    truncateDf = truncateDf.replaceAll(new RegExp(r".cfg"), "");
    print("trucateDf: ${truncateDf}");
    return new GestureDetector(
        onTap: () {

          handleTap(context);
        },
        child: new Container(
            color: bgColor,
            child: new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(18.0),
                  child: new Text(truncateDf,
                      textAlign: TextAlign.left, textScaleFactor: f1),
                ),
              ],
            )));
  }
  void handleTap (BuildContext context) async{
    print("Tapped: ${fullPath}");
    String  response=await new GetS3Object().getS3ObjectAsString(fullPath);
    RaceConfig raceConfig= RaceConfig.fromXml(response);

    if(raceConfig.applicationUrl.isEmpty){
      print("Redisplaying list with bucket ${raceConfig.s3BucketUrlPrefix}");
      RaceSelection2.loadAndPush(context,raceConfig.s3BucketUrlPrefix);
    }
    else{
      String  derbyXml=await new GetS3Object().getS3ObjectAsFile("${raceConfig.s3BucketUrlPrefix}/derby.00000.gz");

      print ("got gzip: "+derbyXml.length.toString());
    }
  }

}
