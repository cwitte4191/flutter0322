import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;

class GetS3Object {
  Future<Map<String,String>> getS3BucketList(String target) async {
    var httpClient = new HttpClient();
    var uri = new Uri.http('s3.amazonaws.com', target, {});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    print("response: " + responseBody);
    var document=xml.parse(responseBody);
    print("response document: " + document.toString());
    for(var child in document.lastChild.children){
      print("response child: " + child.toString());

    }
    var rc=new Map<String,String>();
    for (var key in document.findAllElements("Key")){
      print("response key: " + key.toString());
      var keyString=key.descendants
          .where((node) => node is xml.XmlText && !node.text.trim().isEmpty).join("");
      print("response file/bucket: " + keyString);
rc[keyString]="${target}/${keyString}";
    }
    return rc;
  }
  Future<Map<String,String>> getS3Object(String target) async {
  var httpClient = new HttpClient();
  var uri = new Uri.http('s3.amazonaws.com', target, {});
  var request = await httpClient.getUrl(uri);
  var response = await request.close();
  var responseBody = await response.transform(UTF8.decoder).join();
  print("gso response: " + responseBody);
  var document=xml.parse(responseBody);
  print("gso response document: " + document.toString());
  for(var child in document.lastChild.children){
  print("gso response child: " + child.toString());

  }
  var rc=new Map<String,String>();

  return rc;
  }
}
