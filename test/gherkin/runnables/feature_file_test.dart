import 'package:gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/feature.dart';
import 'package:gherkin/src/gherkin/runnables/feature_file.dart';
import 'package:gherkin/src/gherkin/runnables/language.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation('', 0, null);
  group('addChild', () {
    test('can add LanguageRunnable', () {
      final runnable = FeatureFile(debugInfo);
      runnable.addChild(LanguageRunnable(debugInfo)..language = 'en');
      expect(runnable.language, 'en');
    });
    test('can add TagsRunnable', () {
      final runnable = FeatureFile(debugInfo);
      runnable.addChild(FeatureRunnable('1', debugInfo));
      runnable.addChild(FeatureRunnable('2', debugInfo));
      runnable.addChild(FeatureRunnable('3', debugInfo));
      expect(runnable.features.length, 3);
    });
    test('can add CommentLineRunnable', () {
      final runnable = FeatureFile(debugInfo);
      runnable.addChild(CommentLineRunnable('1', debugInfo));
      expect(runnable.features.length, 0);
    });
  });
}
