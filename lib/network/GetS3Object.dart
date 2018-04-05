import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml/nodes/document.dart';

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
  /*
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  */
  Future<String> getS3ObjectAsFile(String target) async {

    String fname="foo.txt";
    /*
    new HttpClient().getUrl(Uri.parse('http://example.com'))
        .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) =>
        response.pipe(new File(fname).openWrite()));
        */
    print("Downloading object: ${target}");
    var httpClient = new HttpClient();
    var uri = new Uri().resolve(target);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.join();

    return responseBody;

  }


}

class RaceConfig{
  final String applicationUrl;
  final String s3BucketUrlPrefix;
  RaceConfig({this.applicationUrl,this.s3BucketUrlPrefix}){}
  static RaceConfig fromXml(String xmlString){
    var document = xml.parse(xmlString);
    print("RaceConfig fromXml: " + document.toString());
    String applicationUrl=getTextForTag(document,"applicationUrl");
    String s3BucketUrlPrefix=getTextForTag(document,"s3BucketUrlPrefix");
    return new RaceConfig(applicationUrl: applicationUrl,s3BucketUrlPrefix: s3BucketUrlPrefix);

  }
  static String getTextForTag(XmlDocument doc,String tag) {
    String rc="";
    for (var child in doc.findAllElements(tag)){
      print("getTextForTag child {$tag}: " + child.toString());
      rc=child.text;
    }
    return rc;
  }
}
