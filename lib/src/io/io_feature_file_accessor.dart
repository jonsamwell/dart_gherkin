import 'dart:convert';
import 'dart:io';

import 'package:gherkin/src/io/feature_file_matcher.dart';
import 'package:gherkin/src/io/feature_file_reader.dart';
import 'package:path/path.dart';

class IoFeatureFileAccessor implements FeatureFileMatcher, FeatureFileReader {
  final Encoding encoding;
  final Directory? workingDirectory;

  const IoFeatureFileAccessor({
    this.encoding = utf8,
    this.workingDirectory,
  });

  @override
  Future<String> read(String path) {
    return File(path).readAsString(encoding: encoding);
  }

  @override
  Future<List<String>> listFiles(Pattern pattern) {
    return _directoryContents(
      workingDirectory ?? Directory.current,
      pattern,
    );
  }

  /// Returns a list of relative paths from [dir] which match [pattern].
  Future<List<String>> _directoryContents(
    Directory directory,
    Pattern pattern,
  ) async {
    final result = <String>[];

    await directory.list(recursive: true).forEach(
      (item) {
        if (item is File) {
          final relativePath = relative(
            item.path,
            from: directory.path,
          );

          final match = pattern.matchAsPrefix(relativePath);
          if (match?.group(0) == relativePath) {
            result.add(item.path);
          }
        }
      },
    );

    return result;
  }
}
