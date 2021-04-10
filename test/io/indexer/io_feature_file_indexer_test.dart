import 'package:gherkin/src/io/indexer/io_feature_file_indexer.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

void main() {
  group('file indexer', () {
    final indexer = IoFeatureFileIndexer();

    group('with RegExp', () {
      test('lists all matching files', () async {
        expect(
          await indexer.listFiles(RegExp(r'test_resources/.*\.feature')),
          [
            'test_resources/a.feature',
            'test_resources/subdir/b.feature',
            'test_resources/subdir/c.feature',
          ],
        );
      });

      test('lists files from subdirectory', () async {
        expect(
          await indexer.listFiles(RegExp(r'test_resources/subdir/.*\.feature')),
          [
            'test_resources/subdir/b.feature',
            'test_resources/subdir/c.feature',
          ],
        );
      });

      test('doesnt list directories', () async {
        expect(
          await indexer.listFiles(RegExp(r'test_resources')),
          [],
        );
      });

      test('doesnt throw error for weird paths', () async {
        expect(
          await indexer.listFiles(RegExp(r'nonexistentpath')),
          [],
        );
      });
    });

    group('Glob', () {
      test('lists all matching files', () async {
        expect(
          await indexer.listFiles(Glob('test_resources/**.feature')),
          [
            'test_resources/a.feature',
            'test_resources/subdir/b.feature',
            'test_resources/subdir/c.feature',
          ],
        );
      });

      test('list all matching file without subdirectories', () async {
        expect(
          await indexer.listFiles(Glob('test_resources/*.feature')),
          ['test_resources/a.feature'],
        );
      });

      test('doesnt return directories', () async {
        expect(
          await indexer.listFiles(Glob('test_resources/')),
          [],
        );
      });

      test('doesnt throw error for weird paths', () async {
        expect(
          await indexer.listFiles(Glob('nonexistentpath')),
          [],
        );
      });
    });

    group('String', () {
      test('lists one specified file', () async {
        expect(
          await indexer.listFiles('test_resources/a.feature'),
          [
            'test_resources/a.feature',
          ],
        );
      });

      test('doesnt return directories', () async {
        expect(
          await indexer.listFiles('test_resources/'),
          [],
        );
      });

      test('doesnt throw error for weird paths', () async {
        expect(
          await indexer.listFiles('nonexistentpath'),
          [],
        );
      });
    });
  });
}
