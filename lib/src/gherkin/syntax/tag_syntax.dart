import 'package:gherkin/src/gherkin/languages/dialect.dart';

import './regex_matched_syntax.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/tags.dart';

class TagSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect? dialect) => RegExp('^@', multiLine: false, caseSensitive: false);

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) {
    final runnable = TagsRunnable(debug);
    runnable.tags = line.trim().split(RegExp('@')).where((t) => t.isNotEmpty).map((t) => '@${t.trim()}').toList();

    return runnable;
  }
}
