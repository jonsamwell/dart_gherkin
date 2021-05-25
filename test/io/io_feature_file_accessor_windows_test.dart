@TestOn('windows')

import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

import 'path_part_matcher.dart';

void main() {
  group('Matcher', () {
    final indexer = IoFeatureFileAccessor();

    group('with RegExp', () {
      test('lists all matching files', () async {
        expect(
          await indexer
              .listFiles(RegExp(r'test\\test_resources\\(.*).feature')),
          PathPartMatcher([
            r'test\test_resources\a.feature',
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ]),
        );
      });

      test('lists files from subdirectory', () async {
        expect(
          await indexer
              .listFiles(RegExp(r'test\\test_resources\\subdir\\.*\.feature')),
          PathPartMatcher([
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ]),
        );
      });
    });

    group('Glob', () {
      test('lists all matching files', () async {
        expect(
          await indexer.listFiles(Glob('test/test_resources/**.feature')),
          PathPartMatcher([
            r'test\test_resources\a.feature',
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ]),
        );
      });

      test('list all matching file without subdirectories', () async {
        expect(
          await indexer.listFiles(Glob('test/test_resources/*.feature')),
          PathPartMatcher([
            r'test\test_resources\a.feature',
          ]),
        );
      });
    });

    group('String', () {
      test('lists one specified file', () async {
        expect(
          await indexer.listFiles(r'test\test_resources\a.feature'),
          PathPartMatcher([
            r'test\test_resources\a.feature',
          ]),
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
  });
}
