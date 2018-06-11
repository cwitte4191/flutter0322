import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class Md5Utils {
   Future<int> calcMd5(File ndjson) async {
     print ("calcMd5 begin.");
    Stream<List<int>> inputStream = ndjson.openRead();
    Stream<String> lineStream = await inputStream
        .transform(new Utf8Decoder());
    Stream<Digest> foo=md5.bind(inputStream); // ignore: new_with_undefined_constructor_default
    try {
      await for (var digest in foo) {
        print("calcMd5: $digest");
      }
    } catch (e) {
      print("calcMd5: error: $e");

      return -1;
    }
     print ("calcMd5 done.");

   }
}
