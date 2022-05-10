import '../languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/tags.dart';
import 'regex_matched_syntax.dart';

enum AnnotatingBlock { examples, feature, scenarioOutline, scenario }

class TagSyntax extends RegExMatchedGherkinSyntax<TagsRunnable> {
  /// The block following this line such as `Examples` or `Feature`
  AnnotatingBlock? annotating;

  @override
  RegExp pattern(GherkinDialect dialect) => RegExp(
        '^@',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  TagsRunnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final runnable = TagsRunnable(debug);
    runnable.tags = line
        .trim()
        .split(RegExp('@'))
        .where((t) => t.isNotEmpty)
        .map((t) => '@${t.trim()}')
        .toList();

    return runnable;
  }

  static AnnotatingBlock? determineAnnotationBlock(
    String nextLine,
    GherkinDialect dialect,
  ) {
    final blockLabels = [
      dialect.examples,
      dialect.feature,
      dialect.scenarioOutline,
      dialect.scenario,
    ]
        .map((b) => RegExMatchedGherkinSyntax.getMultiDialectRegexPattern(b))
        .toList();
    for (final dialectPattern in blockLabels) {
      final regex = RegExp('^\\s*(?:$dialectPattern)');
      if (nextLine.startsWith(regex)) {
        return AnnotatingBlock.values[blockLabels.indexOf(dialectPattern)];
      }
    }
    return null;
  }
}
