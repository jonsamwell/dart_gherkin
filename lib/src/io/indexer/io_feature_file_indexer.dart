import 'dart:io';
import 'package:path/path.dart';

import 'package:gherkin/src/io/indexer/feature_file_indexer.dart';

class IoFeatureFileIndexer implements FeatureFileIndexer {
  @override
  Future<List<String>> listFiles(Pattern pattern) async {
    return await _directoryContents(
      Directory.current,
      pattern,
    );
  }

  /// Returns list of relative paths from [dir] which math [pattern].
  Future<List<String>> _directoryContents(
    Directory dir,
    Pattern pattern,
  ) async {
    final result = <String>[];

    await dir.list(recursive: true).forEach(
      (item) {
        if (item is File) {
          final relativePath = relative(
            item.path,
            from: Directory.current.path,
          );

          final match = pattern.matchAsPrefix(relativePath);
          if (match?.group(0) == relativePath) {
            result.add(relativePath);
          }
        }
      },
    );

    return result;
  }
}
