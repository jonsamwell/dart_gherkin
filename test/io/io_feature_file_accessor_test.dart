import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

void main() {
  group('Matcher', () {
    final indexer = IoFeatureFileAccessor();

    group('with RegExp', () {
      test('does not list directories', () async {
        expect(
          indexer.listFiles(RegExp(r'test_resources')),
          [],
        );
      });

      test('does not throw error for weird paths', () async {
        expect(
          indexer.listFiles(RegExp(r'nonexistentpath')),
          [],
        );
      });
    });

    group('Glob', () {
      test('does not return directories', () async {
        expect(
          indexer.listFiles(Glob('test/test_resources/')),
          [],
        );
      });

      test('does not throw error for weird paths', () async {
        expect(
          indexer.listFiles(Glob('nonexistentpath')),
          [],
        );
      });
    });

    group('String', () {
      test('does not return directories', () async {
        expect(
          indexer.listFiles('test/test_resources/'),
          [],
        );
      });

      test('does not throw error for weird paths', () async {
        expect(
          indexer.listFiles('nonexistentpath'),
          [],
        );
      });
    });
  });

  group('Reader', () {
    test('file contents are read', () async {
      final indexer = IoFeatureFileAccessor();

      expect(
        indexer.read('test/test_resources/a.feature'),
        'Feature: A',
      );
    });

    test('file system exception is thrown when file does not exist', () async {
      final indexer = IoFeatureFileAccessor();

      expect(
        () => indexer.read('nonexistentpath'),
        throwsA(TypeMatcher<FileSystemException>()),
      );
    });
  });
}
