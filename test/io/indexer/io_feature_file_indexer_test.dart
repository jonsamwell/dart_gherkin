import 'package:gherkin/src/io/indexer/io_feature_file_indexer.dart';
import 'package:test/test.dart';

void main() {
  group('run', () {
    test('matching files from current directory are listed', () async {
      final indexer = IoFeatureFileIndexer();

      expect(
        await indexer.listFiles(RegExp(r'test_resources/.*\.feature')),
        [
          'test_resources/a.feature',
          'test_resources/subdir/b.feature',
          'test_resources/subdir/c.feature',
        ],
      );

      expect(
        await indexer.listFiles(RegExp(r'test_resources/subdir/.*\.feature')),
        [
          'test_resources/subdir/b.feature',
          'test_resources/subdir/c.feature',
        ],
      );

      expect(
        await indexer.listFiles(RegExp(r'nonexistentpath')),
        [],
      );
    });
  });
}
