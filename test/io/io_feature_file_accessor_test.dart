import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

void main() {
  group('Matcher', () {
    final indexer = IoFeatureFileAccessor();

    group('with RegExp', () {
      test('lists all matching files', () async {
        expect(
          await indexer
              .listFiles(RegExp(r'test\\test_resources\\(.*)\.feature')),
          [
            r'test\test_resources\a.feature',
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ],
        );
      });

      test('lists files from subdirectory', () async {
        expect(
          await indexer
              .listFiles(RegExp(r'test\\test_resources\\subdir\\.*\.feature')),
          [
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ],
        );
      });

      test('does not list directories', () async {
        expect(
          await indexer.listFiles(RegExp(r'test_resources')),
          [],
        );
      });

      test('does not throw error for weird paths', () async {
        expect(
          await indexer.listFiles(RegExp(r'nonexistentpath')),
          [],
        );
      });
    });

    group('Glob', () {
      test('lists all matching files', () async {
        expect(
          await indexer.listFiles(Glob('test/test_resources/**.feature')),
          [
            r'test\test_resources\a.feature',
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ],
        );
      });

      test('list all matching file without subdirectories', () async {
        expect(
          await indexer.listFiles(Glob('test/test_resources/*.feature')),
          [
            r'test\test_resources\a.feature',
          ],
        );
      });

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
      test('lists one specified file', () async {
        expect(
          await indexer.listFiles(r'test\test_resources\a.feature'),
          [
            r'test\test_resources\a.feature',
          ],
        );
      });

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
      final indexer = IoFeatureFileAccessor();

      expect(
        await indexer.read('test/test_resources/a.feature'),
        'Feature: A',
      );
    });

    test('file system exception is thrown when file does not exist', () async {
      final indexer = IoFeatureFileAccessor();

      expect(
        indexer.read('nonexistentpath'),
        throwsA(TypeMatcher<FileSystemException>()),
      );
    });
  });
}
