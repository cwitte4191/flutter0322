import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import 'package:flutter0322/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml/nodes/document.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart';
import 'package:flutter0322/globals.dart' as globals;

import 'package:semaphore/semaphore.dart';

class GetS3Object {
  Future<Map<String, String>> getS3BucketList(String targetUrl) async {
    var httpClient = new HttpClient();
    var uri = new Uri().resolve(targetUrl);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
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
    var responseBody = await response.transform(UTF8.decoder).join();
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

  Future<File> ndJsonFile() async {
    return _localFile(fileName:"dataLog.ndjson");
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

  Future<File> _resumeS3ObjectAsFile(String target,
      File fName) async {

    List<int> resumeTime=new List();
    resumeTime.add( DateTime.now().millisecondsSinceEpoch);

    print("Resume Download begin ${fName.path}");

    FileStat fstat = await FileStat.stat(fName.path);
    int resumeFrom = 0;
    if (fstat.type == FileSystemEntityType.NOT_FOUND) {
      print("Resume Download from FileNotFound");

    } else {
      print("_resume prior Length of file ${fName} is ${fstat.size}");
      resumeFrom = fstat.size;
    }

    var sink1 = fName.openWrite(mode: FileMode.WRITE_ONLY_APPEND);
    HttpClientResponse response = await new HttpClient()
        .getUrl(Uri.parse(target))
        .then((HttpClientRequest request) {
          request.headers..add(HttpHeaders.RANGE, "bytes=${resumeFrom}-");
          return request;
        })
        .then((HttpClientRequest request) => request.close());

        await response.pipe(sink1);
    //await sink1.close();
    FileStat fstat2 = await FileStat.stat(fName.path);
    if (fstat.type == FileSystemEntityType.NOT_FOUND) {
      print("_resume after ERROR NOT FOUND file ${fName}");

    } else {
      print("_resume after Length of file ${fName} is ${fstat.size}");
      resumeFrom = fstat.size;
    }
    resumeTime.add( DateTime.now().millisecondsSinceEpoch);
    this.reportElapsed(resumeTime,"resumeDownload");

    return fName;
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

  Future<File> getS3ObjectAsFile(String target,
      File fname) async {
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
    //var rbd= JSON.decode(getRbdJson());

    /*
    print("Downloading object: ${target}");
    var httpClient = new HttpClient();
    var uri = new Uri().resolve(target);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.join();

    return responseBody;
    */
  }

  void reportElapsed(List<int>times,String literal) {
    var start=times[0];
    for( var x in times){
      print ("$literal elapsed time: ${x - start}");
    }
  }
}

//class RefreshData<T extends HasJsonMap>{
//Future<List<T>> doRefresh(RaceConfig raceConfig,String serializedName) async {

class RefreshData {
  Future<Map<int, T>> doRefresh<T>(String serializedName,
      {RaceConfig raceConfig}) async {
    GetS3Object gs30 = new GetS3Object();
    if (raceConfig == null) {
      raceConfig = globals.globalDerby.raceConfig;
    }
    List<int> ptime=new List();
    ptime.add( DateTime.now().millisecondsSinceEpoch);
    String url = "${raceConfig.s3BucketUrlPrefix}/dataLog.ndjson";

    File ndjson=await gs30.ndJsonFile();
    if(false) {
      ndjson =
      await gs30.getS3ObjectAsFile(url, ndjson);
    }
    else{
      ndjson=await gs30._resumeS3ObjectAsFile(url,ndjson);
    }
    globals.globalDerby.ndJsonPath=ndjson;
    ptime.add( DateTime.now().millisecondsSinceEpoch);

    print("doRefresh begin: " + serializedName);
    print(" ndjson: ${ndjson}");

    Stream<List<int>> inputStream = ndjson.openRead();
    int accumulatedBytes = 0;


    bool stringFilter(String event) {
      var q="\"";
      var pattern = new RegExp("${q}sn${q}:${q}${serializedName}${q}");
      return event.contains(pattern);
    }

    List<String> jj = await inputStream
        .transform(new Utf8Decoder())
        .transform(new LineSplitter())
        .where(stringFilter)
        .toList();
    ;
    ptime.add( DateTime.now().millisecondsSinceEpoch);


    print("jj matching strings:" + jj.length.toString());

    int count = 0;
    SplayTreeMap<int, T> rcMap = new SplayTreeMap();

    for (String line in jj) {
      parseLine(line, serializedName, rcMap);
    }
    print("jj mapSize :" + rcMap.length.toString());
    ptime.add( DateTime.now().millisecondsSinceEpoch);

    /*
    await for (var line in lines) {
      count++;
      print("line:" + count.toString() + " " + line);
      continue; //TODO: wip to see why we error.
      parseLine(line,serializedName,rcMap);

    }
    */
    if(serializedName=="Racer"){
      globals.globalDerby.racerMap=rcMap as Map<int, Racer>;
    }
    if(serializedName=="RaceBracket"){
      globals.globalDerby.bracketMap=rcMap as Map<int, RaceBracket>;
    }
    print("doRefresh: done2 await: ${ndjson} map size: " +
        rcMap.length.toString());

    gs30.reportElapsed(ptime,"doRefresh");

    return rcMap;
  }


  void parseLine<T>(String line, String serializedName, Map<int, T> rcMap) {
    var foo = JSON.decode(line);
    print("sn:" + foo["sn"]);
    if (foo["sn"] != serializedName) {
      return;
    }

    if (serializedName == "Racer") {
      Racer r = new Racer.fromJsonMap(foo["data"]);
      //print("Racer:" + r.carNumber.toString() + " : " + r.racerName);
      if (foo["type"] == "Remove") {
        rcMap.remove(r.carNumber);
      } else {
        rcMap[r.carNumber] = (r as T);
      }
    }

    if (serializedName == "RacePhase") {
      RacePhase r = new RacePhase.fromJsonMap(foo["data"]);
      //print("Racer:" + r.carNumber.toString() + " : " + r.racerName);
      if (foo["type"] == "Remove") {
        rcMap.remove(r.id);
      } else {
        rcMap[r.id] = (r as T);
      }
    }
    if (serializedName == "RaceStanding") {
      RaceStanding r = new RaceStanding.fromJsonMap(foo["data"]);
      //print("Racer:" + r.carNumber.toString() + " : " + r.racerName);
      if (foo["type"] == "Remove") {
        rcMap.remove(r.id);
      } else {
        rcMap[r.id] = (r as T);
      }
    }
    if (serializedName == "RaceBracket") {
      RaceBracket r = new RaceBracket.fromJsonMap(foo["data"]);

      if(r.id==null){ // happens on persist, ,not merge!?
        return;
      }
      //print("Racer:" + r.carNumber.toString() + " : " + r.racerName);
      if (foo["type"] == "Remove") {
        rcMap.remove(r.id);
      } else {
        rcMap[r.id] = (r as T);
      }
    }
  }
  /*
  void setStateFoo(VoidCallback fn) {
    print("setState list size prior:" + list.length.toString());
    fn();
    print("setState list size post:" + list.length.toString());
  }

  List<Racer> list = [];
  void streamFrom() {
    StreamController<Racer> streamController = new StreamController.broadcast();
    streamController.stream.listen((p) => setStateFoo(() => list.add(p)));
    load(streamController);
  }
  */

  void load(StreamController<Racer> sc) async {
    String url = "";
    var client = new HttpClient();
    var uri = new Uri().resolve(url);
    var request = await client.getUrl(uri);
    //request.
    var streamedResponse = await request.close();
    streamedResponse
        .transform(new Utf8Decoder())
        .transform(json.decoder)
        .expand((e) => e)
        .map((map) => Racer.fromJsonMap(map))
        .pipe(sc);
    ;
  }
}

class RaceConfig {
  final String applicationUrl;
  final String s3BucketUrlPrefix;
  RaceConfig({this.applicationUrl, this.s3BucketUrlPrefix}) {}
  static RaceConfig fromXml(String xmlString) {
    var document = xml.parse(xmlString);
    print("RaceConfig fromXml: " + document.toString());
    String applicationUrl = getTextForTag(document, "applicationUrl");
    String s3BucketUrlPrefix = getTextForTag(document, "s3BucketUrlPrefix");
    return new RaceConfig(
        applicationUrl: applicationUrl, s3BucketUrlPrefix: s3BucketUrlPrefix);
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
