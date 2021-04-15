@TestOn('windows')

import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

void main() {
  group('Matcher', () {
    final indexer = IoFeatureFileAccessor();

    group('with RegExp', () {
      test('lists all matching files', () async {
        expect(
          indexer.listFiles(RegExp(r'test\\test_resources\\(.*).feature')),
          [
            r'test\test_resources\a.feature',
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ],
        );
      });

      test('lists files from subdirectory', () async {
        expect(
          indexer
              .listFiles(RegExp(r'test\\test_resources\\subdir\\.*\.feature')),
          [
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ],
        );
      });
    });

    group('Glob', () {
      test('lists all matching files', () async {
        expect(
          indexer.listFiles(Glob('test/test_resources/**.feature')),
          [
            r'test\test_resources\a.feature',
            r'test\test_resources\subdir\b.feature',
            r'test\test_resources\subdir\c.feature',
          ],
        );
      });

      test('list all matching file without subdirectories', () async {
        expect(
          indexer.listFiles(Glob('test/test_resources/*.feature')),
          [
            r'test\test_resources\a.feature',
          ],
        );
      });
    });

    group('String', () {
      test('lists one specified file', () async {
        expect(
          indexer.listFiles(r'test\test_resources\a.feature'),
          [
            r'test\test_resources\a.feature',
          ],
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
  });
}
