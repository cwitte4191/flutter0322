import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

class Md5Utils {
  Future<Digest> calcSha1(File ndjson) async {
    print("calcSha1 begin.");
    Digest rc;
    Stream<List<int>> inputStream = ndjson.openRead();
    Stream<String> lineStream = await inputStream.transform(new Utf8Decoder());
    Stream<Digest> foo =
        sha1.bind(inputStream); // ignore: new_with_undefined_constructor_default
    try {
      await for (var digest in foo) {
        print("calcSha1: $digest");
        rc=digest;
      }
    } catch (e) {
      print("calcSha1: error: $e");

      return null;
    }
    print("calcMd5 done.");
    return rc;
  }
}
