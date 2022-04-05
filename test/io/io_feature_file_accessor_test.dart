import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

void main() {
  group('Matcher', () {
    const indexer = IoFeatureFileAccessor();

    group('with RegExp', () {
      test('does not list directories', () async {
        expect(
          await indexer.listFiles(RegExp('test_resources')),
          [],
        );
      });

      test('does not throw error for weird paths', () async {
        expect(
          await indexer.listFiles(RegExp('nonexistentpath')),
          [],
        );
      });
    });

    group('Glob', () {
      test('does not return directories', () async {
        expect(
          await indexer.listFiles(Glob('test/test_resources/')),
          [],
        );
      });

      test('does not throw error for weird paths', () async {
        expect(
          await indexer.listFiles(Glob('nonexistentpath')),
          [],
        );
      });
    });

    group('String', () {
      test('does not return directories', () async {
        expect(
          await indexer.listFiles('test/test_resources/'),
          [],
        );
      });

      test('does not throw error for weird paths', () async {
        expect(
          await indexer.listFiles('nonexistentpath'),
          [],
        );
      });
    });
  });

  group('Reader', () {
    test('file contents are read', () async {
      const indexer = IoFeatureFileAccessor();

      expect(
        await indexer.read('test/test_resources/a.feature'),
        'Feature: A',
      );
    });

    test('file system exception is thrown when file does not exist', () async {
      const indexer = IoFeatureFileAccessor();

      expect(
        () => indexer.read('nonexistentpath'),
        throwsA(const TypeMatcher<FileSystemException>()),
      );
    });
  });
}
