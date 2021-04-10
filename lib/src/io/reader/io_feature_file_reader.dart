import 'dart:convert';
import 'dart:io';

import 'feature_file_reader.dart';

class IoFeatureFileReader implements FeatureFileReader {
  final Encoding encoding;

  IoFeatureFileReader({this.encoding = utf8});

  @override
  Future<String> readAsString(String path) async {
    return await File(path).readAsString(encoding: encoding);
  }
}
