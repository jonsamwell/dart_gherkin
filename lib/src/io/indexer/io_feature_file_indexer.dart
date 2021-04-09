import 'dart:io';
import 'package:path/path.dart';

import 'package:gherkin/src/io/indexer/feature_file_indexer.dart';

class IoFeatureFileIndexer implements FeatureFileIndexer {
  @override
  Future<List<String>> listFiles(Pattern pattern) async {
    final directoryContents = await _directoryContents(Directory.current);
    return directoryContents
        .map((e) => relative(e.path, from: Directory.current.path))
        .where((e) => pattern.allMatches(e).isNotEmpty)
        .toList();
  }

  Future<List<FileSystemEntity>> _directoryContents(Directory dir) async {
    final result = <FileSystemEntity>[];
    await dir.list(recursive: true).forEach((event) {
      result.add(event);
    });
    return result;
  }
}
