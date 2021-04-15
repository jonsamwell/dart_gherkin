import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:gherkin/src/io/feature_file_matcher.dart';

import 'feature_file_reader.dart';

class IoFeatureFileAccessor implements FeatureFileMatcher, FeatureFileReader {
  final Encoding encoding;
  final Directory? workingDirectory;

  const IoFeatureFileAccessor({
    this.encoding = utf8,
    this.workingDirectory,
  });

  @override
  String read(String path) {
    return File(path).readAsStringSync(encoding: encoding);
  }

  @override
  List<String> listFiles(Pattern pattern) {
    return _directoryContents(
      workingDirectory ?? Directory.current,
      pattern,
    );
  }

  /// Returns a list of relative paths from [dir] which match [pattern].
  List<String> _directoryContents(
    Directory directory,
    Pattern pattern,
  ) {
    final files = directory.listSync(recursive: true);
    return files.fold<List<String>>(<String>[], (acc, item) {
      if (item is File) {
        final relativePath = relative(
          item.path,
          from: directory.path,
        );

        final match = pattern.matchAsPrefix(relativePath);
        if (match?.group(0) == relativePath) {
          acc.add(relativePath);
        }
      }
      return acc;
    });
  }
}
