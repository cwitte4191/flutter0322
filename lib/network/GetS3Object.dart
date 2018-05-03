import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:convert';
import '../models.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml/nodes/document.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart';
import '../globals.dart' as globals;

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
    print("gso response: " + responseBody);

    return responseBody;
  }

  Future<String> get _localPath async {
    //final directory = await getApplicationDocumentsDirectory();
    Directory dir = Directory.systemTemp;
    print("temp dir: " + dir.path);

    return dir.path;
  }

  Future<File> _localFile({prefix = "foo"}) async {
    final path = await _localPath;
    return new File('$path/$prefix.foo');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile();

    // Write the file
    return file.writeAsString('$counter');
  }

  Future<File> resumeS3ObjectAsFile(String target,
      {String localBasename = "MissingF"}) async {
    File fname = await _localFile(prefix: localBasename);
    print("Resume Download begin ${localBasename}");

    FileStat fstat = await FileStat.stat(fname.path);
    int resumeFrom = 0;
    if (fstat.type == FileSystemEntityType.NOT_FOUND) {} else {
      print("Length of file ${fname} is ${fstat.size}");
      resumeFrom = fstat.size;
    }

    var sink1 = fname.openWrite(mode: FileMode.WRITE_ONLY_APPEND);
    await new HttpClient()
        .getUrl(Uri.parse(target))
        .then((HttpClientRequest request) {
          request.headers..add(HttpHeaders.RANGE, "bytes=${resumeFrom}-");
          return request;
        })
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) => response.pipe(sink1));
    await sink1.close();

    return fname;
  }

  Future<File> getS3ObjectAsFile(String target,
      {String localBasename = "MissingF"}) async {
    File fname = await _localFile(prefix: localBasename);
    print("Download from ${target} begin ${localBasename}");

    FileStat fstat = await FileStat.stat(fname.path);
    print("Length of file before ${fname} is ${fstat.size}");
    //var sink1 = fname.openWrite();
    var httpStatus = -1;
    await new HttpClient()
        .getUrl(Uri.parse(target))
        .then((HttpClientRequest request) {
          request.headers..add(HttpHeaders.CONTENT_TYPE, "text/plain");
          return request;
        })
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) {
          httpStatus = response.statusCode;
          print("Download in flight ${localBasename} status: $httpStatus");

          //response.pipe(sink1);
          response.pipe(fname.openWrite());
        });
    //await sink1.close();
    print("Download complete ${localBasename} status: $httpStatus");
    print("Length of file after ${fname} is ${fstat.size}");
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
}

//class RefreshData<T extends HasJsonMap>{
//Future<List<T>> doRefresh(RaceConfig raceConfig,String serializedName) async {

class RefreshData {
  Future<Map<int, T>> doRefresh<T>(String serializedName,
      {RaceConfig raceConfig}) async {
    if (raceConfig == null) {
      raceConfig = globals.raceConfig;
    }
    File ndjson = await new GetS3Object().getS3ObjectAsFile(
        "${raceConfig.s3BucketUrlPrefix}/dataLog.ndjson",
        localBasename: "dataLog.ndjson");

    print(" ndjson: ${ndjson}");
    print("File content: " + " ${await(ndjson.readAsString(encoding: ASCII))}");

    var lines = await ndjson
        .openRead()
        .transform(new Utf8Decoder())
        .transform(const LineSplitter());
    print(" begin await: ${ndjson}");
    print(" begin await Type T:");

    SplayTreeMap<int, T> rcMap = new SplayTreeMap();
    await for (var line in lines) {
      print("line:" + line);
      var foo = JSON.decode(line);
      print("sn:" + foo["sn"]);
      if (foo["sn"] != serializedName) {
        continue;
      }

      if(serializedName=="Racer") {
        Racer r = new Racer.fromJsonMap(foo["data"]);
        //print("Racer:" + r.carNumber.toString() + " : " + r.racerName);
        if (foo["type"] == "Remove") {
          rcMap.remove(r.carNumber);
        } else {
          rcMap[r.carNumber] = (r as T);
        }
      }

      if(serializedName=="RacePhase") {
        RacePhase r = new RacePhase.fromJsonMap(foo["data"]);
        //print("Racer:" + r.carNumber.toString() + " : " + r.racerName);
        if (foo["type"] == "Remove") {
          rcMap.remove(r.id);
        } else {
          rcMap[r.id] = (r as T);
        }
      }
    }
    print(" done2 await: ${ndjson}");

    return rcMap;
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
