import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/tags.dart';
import './regex_matched_syntax.dart';

class TagSyntax extends RegExMatchedGherkinSyntax<TagsRunnable> {
  @override
  RegExp pattern(GherkinDialect dialect) =>
      RegExp('^@', multiLine: false, caseSensitive: false);

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
}
