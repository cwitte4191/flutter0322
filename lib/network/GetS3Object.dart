import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import 'package:flutter0322/models/ModelFactory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml/nodes/document.dart';
import 'package:flutter0322/globals.dart' as globals;

class GetS3Object {
  Future<Map<String, String>> getS3BucketList(String targetUrl) async {
    var httpClient = new HttpClient();
    var uri = new Uri().resolve(targetUrl);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(new Utf8Decoder()).join();
    print("response: " + responseBody);
    var document = xml.parse(responseBody);
    print("response document: " + document.toString());
    for (var child in document.lastChild.children) {
      print("response child: " + child.toString());
    }
    var rc = new Map<String, String>();
    for (var key in document.findAllElements("Key")) {
      print("response key: " + key.toString());
      var keyString = key.descendants
          .where((node) => node is xml.XmlText && !node.text.trim().isEmpty)
          .join("");
      print("response file/bucket: " + keyString);
      rc[keyString] = "${targetUrl}/${keyString}";
    }
    return rc;
  }

  Future<String> getS3ObjectAsString(String target) async {
    print("Downloading object: ${target}");
    var httpClient = new HttpClient();
    var uri = new Uri().resolve(target);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(new Utf8Decoder()).join();
    // print("gso response: " + responseBody);

    return responseBody;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print("appDocuments: ${directory.path}");
    return directory.path;
    /*
    Directory dir = Directory.systemTemp;
    print("temp dir: " + dir.path);

    return dir.path;
    */
  }

  Future<File> tmpFile() async {
    var ms=new DateTime.now().millisecondsSinceEpoch.toString();
    return _localFile(fileName: "dataLog_${ms}.ndjson");
  }
  Future<File> ndJsonFile() async {
    return _localFile(fileName: "dataLog.ndjson");
  }

  Future<File> raceConfigFile() async {
    return _localFile(fileName: "raceConfig.ndjson");
  }

  Future<File> _localFile({fileName = "foo"}) async {
    final path = await _localPath;
    return new File('$path/$fileName');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile();

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<File> _resumeS3ObjectAsFile(String target, File mainFileName) async {
    List<int> resumeTime = new List();
    resumeTime.add(DateTime.now().millisecondsSinceEpoch);

    print("Resume Download consider ${mainFileName.path}");
    print("Resume Download from ${target}");

    int resumeFrom = await getFileLength(mainFileName, "_resume begin");

    if (resumeFrom == 0) {
      print("Resume Download delegating ${mainFileName.path}");

      await getS3ObjectAsFile(target, mainFileName);
      await RefreshData.parseAndLoadFile(mainFileName);

      return mainFileName;
    }
    //var sink1 = fName.openWrite(mode: FileMode.WRITE_ONLY_APPEND);
    print("Resume Download from offset ${resumeFrom}");

    HttpClientResponse response = await new HttpClient()
        .getUrl(Uri.parse(target))
        .then((HttpClientRequest request) {
      request.headers..add(HttpHeaders.RANGE, "bytes=${resumeFrom}-");
      return request;
    }).then((HttpClientRequest request) => request.close());

    print("http response status: ${response.statusCode}");
    if (response.statusCode == 416) {
      print("_resumeS3ObjectAsFile: NOOP");

      return mainFileName;
    }

    if (response.statusCode == 206) {
      var myTmpFile=await tmpFile();
      print("_resumeS3ObjectAsFile: resuming with partial download");

      //IOSink sinkDelta = mainFileName.openWrite(mode: FileMode.WRITE_ONLY_APPEND);
      IOSink sinkDelta = myTmpFile.openWrite();
      await response.pipe(sinkDelta);


      await RefreshData.parseAndLoadFile(myTmpFile);
      await concatenate(appendee: mainFileName, appendage:myTmpFile);
      await myTmpFile.delete();
    }
    await getFileLength(mainFileName, "_resume Done");

    resumeTime.add(DateTime.now().millisecondsSinceEpoch);
    this.reportElapsed(resumeTime, "resumeDownload");

    return mainFileName;
  }

  Future concatenate({File appendee,File appendage})async {
    IOSink sinkDelta = appendee.openWrite(mode: FileMode.WRITE_ONLY_APPEND);
    Stream<List<int>> inputStream = appendage.openRead();

    await inputStream.pipe(sinkDelta);



  }
  void foo1(String target) async {
    await new HttpClient()
        .getUrl(Uri.parse(target))
        .then((HttpClientRequest request) => request.close())
        .then(await (HttpClientResponse response) =>
            response.pipe(new File('foo1.txt').openWrite()));
  }

  void foo2(String target) async {
    HttpClientResponse response = await new HttpClient()
        .getUrl(Uri.parse(target))
        .then((HttpClientRequest request) => request.close());

    print("foo2 hcr:" + response.toString());

    await response.pipe(new File('foo2.txt').openWrite());
    print("foo2 pipe: done");
  }

  Future<File> getS3ObjectAsFile(String target, File fname) async {
    print("Download from ${target} begin ${fname.path}");

    FileStat fstat = await FileStat.stat(fname.path);
    print("Length of file before ${fname} is ${fstat.size}");
    //var sink1 = fname.openWrite();
    var httpStatus = -1;
    HttpClientResponse response = await new HttpClient()
        .getUrl(Uri.parse(target))
        .then((HttpClientRequest request) {
      request.headers..add(HttpHeaders.CONTENT_TYPE, "text/plain");
      return request;
    }).then((HttpClientRequest request) => request.close());

    await response.pipe(fname.openWrite());

    //await sink1.close();
    print("Download complete ${fname.path} status: $httpStatus");
    FileStat fstat2 = await FileStat.stat(fname.path);
    print("Length of file after ${fname} is ${fstat2.size}");
/*
    if (target.endsWith(".gz")) {
      print("Gzip decode begin s ${localBasename}");

      File fname2 = await _localFile(prefix: localBasename + ".uz");
      var sink2 = fname2.openWrite();
      await new GZipDecoder().decodeStream(fname.openRead(), sink2);
      await sink2.close();
      return fname2;
    }
    */
    return fname;
  }

  void reportElapsed(List<int> times, String literal) {
    var start = times[0];
    for (var x in times) {
      print("$literal elapsed time: ${x - start}");
    }
  }

  Future<int> getFileLength(File fName, String s) async {
    FileStat fstat = await FileStat.stat(fName.path);
    if (fstat.type == FileSystemEntityType.NOT_FOUND) {
      print("$s getFileLength  FileNotFound: ${fName.path}");
      return 0;
    } else {
      if (s != null) {
        print("$s getFileLength Length of file ${fName} is ${fstat.size}");
      }
      return fstat.size;
    }
  }
}

class RefreshData {
  RefreshData();
  Future doRefresh<T>({RaceConfig raceConfig}) async {
    GetS3Object gs30 = new GetS3Object();
    if (raceConfig == null) {
      raceConfig = globals.globalDerby.raceConfig;
    }
    List<int> ptime = new List();
    ptime.add(DateTime.now().millisecondsSinceEpoch);
    String url = "${raceConfig.s3BucketUrlPrefix}/dataLog.ndjson";

    File ndjson = await gs30.ndJsonFile();
    if (false) {
      ndjson = await gs30.getS3ObjectAsFile(url, ndjson);
    } else {
      ndjson = await gs30._resumeS3ObjectAsFile(url, ndjson);
    }
    globals.globalDerby.ndJsonPath = ndjson;
    ptime.add(DateTime.now().millisecondsSinceEpoch);

    print("doRefresh begin. ");
    print(" ndjson: ${ndjson}");
    //await parseAndLoadFile(ndjson);  // TODO: DO NOT PARSE/LOAD ENTIRE FILE ON REFRESH!

    ptime.add(DateTime.now().millisecondsSinceEpoch);

    return ;
  }
  static Future parseAndLoadFile(File ndjson)async {
    Stream<List<int>> inputStream = ndjson.openRead();
    int accumulatedBytes = 0;

    Stream<String> lineStream = await inputStream
        .transform(new Utf8Decoder())
        .transform(new LineSplitter());
    await republishStream(lineStream);

  }

  static Future<int> republishStream(Stream<String> stream) async {
    try {
      await for (var line in stream) {
        print("republishStream: $line");
        await ModelFactory.loadDb(line);
      }
    } catch (e) {
      return -1;
    }
    return 0;
  }


}

class RaceConfig {
  final String raceName;
  final String applicationUrl;
  final String s3BucketUrlPrefix;
  RaceConfig({this.applicationUrl, this.s3BucketUrlPrefix, this.raceName}) {}
  RaceConfig.fromJson(Map<String, dynamic> json)
      : raceName = json["raceName"],
        applicationUrl = json["applicationUrl"],
        s3BucketUrlPrefix = json["s3BucketUrlPrefix"];
  Map<String, dynamic> toJson() => {
        'raceName': raceName,
        'applicationUrl': applicationUrl,
        's3BucketUrlPrefix': s3BucketUrlPrefix,
      };
  static RaceConfig fromXml({String xmlString, String raceName}) {
    var document = xml.parse(xmlString);
    print("RaceConfig fromXml: " + document.toString());
    String applicationUrl = getTextForTag(document, "applicationUrl");
    String s3BucketUrlPrefix = getTextForTag(document, "s3BucketUrlPrefix");
    return new RaceConfig(
        applicationUrl: applicationUrl,
        s3BucketUrlPrefix: s3BucketUrlPrefix,
        raceName: raceName);
  }

  String getMqttHostname(){
    String rc=applicationUrl;
    print("getMqttHostname: $rc");
    //TODO: build uri/url and get hostname.  did not find a relevant constructor :-(
    rc=rc.replaceAll("http://", "");
    rc=rc.replaceAll("root@", "");
    Pattern p=new RegExp(":");
    List<String>rcSplit=rc.split(new RegExp(":"));
    rc=rcSplit[0];
    print("getMqttHostname: gave: $rc");

    return rc;
  }
  Future persistToFile() async {
    File rcFile = await new GetS3Object().raceConfigFile();
    var json = new JsonCodec();
    String jsonString = json.encode(this);
    print("persistToFile:  rcFile: ${rcFile.toString()} $jsonString");

    var oStream = await rcFile.openWrite();
    await oStream.write(jsonString);
    await oStream.close();
  }

  static Future<RaceConfig> restoreRaceConfig() async {
    File rcFile = await new GetS3Object().raceConfigFile();
    if (!rcFile.existsSync()) {
      print("restoreRaceConfig: no rcFile: ${rcFile.toString()}");

      return null;
    }
    Stream<List<int>> inputStream = await rcFile.openRead();

    String line = await inputStream
        .transform(new Utf8Decoder())
        .transform(new LineSplitter())
        .first;
    if (line == null) {
      print("restoreRaceConfig: unable to restore raceConfig");
      return null;
    }
    var json = JSON.decode(line);
    print("restoreRaceConfig: found rcFile: $json");

    return new RaceConfig.fromJson(json);
  }

  static String getTextForTag(XmlDocument doc, String tag) {
    String rc = "";
    for (var child in doc.findAllElements(tag)) {
      print("getTextForTag child {$tag}: " + child.toString());
      rc = child.text;
    }
    return rc;
  }
}
