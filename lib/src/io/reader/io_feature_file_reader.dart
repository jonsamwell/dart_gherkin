import 'dart:io';

import 'feature_file_reader.dart';

class IoFeatureFileReader implements FeatureFileReader {
  @override
  Future<String> readAsString(String path) async {
    return await File(path).readAsString();
  }
}