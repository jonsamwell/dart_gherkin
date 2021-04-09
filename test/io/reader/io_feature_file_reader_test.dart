import 'dart:io';

import 'package:gherkin/src/io/reader/io_feature_file_reader.dart';
import 'package:test/test.dart';

void main() {
  group('run', () {
    test('file contents are read', () async {
      final indexer = IoFeatureFileReader();

      expect(
        await indexer.readAsString(('test_resources/a.feature')),
        'Feature: A',
      );
    });

    test('file system exception is thrown when file doesnt exist', () async {
      final indexer = IoFeatureFileReader();

      expect(
        indexer.readAsString('nonexistentpath'),
        throwsA(TypeMatcher<FileSystemException>()),
      );
    });
  });
}
