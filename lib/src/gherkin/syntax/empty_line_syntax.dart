import 'package:gherkin/src/gherkin/languages/dialect.dart';

import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/syntax/regex_matched_syntax.dart';

class EmptyLineSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect dialect) => RegExp(
        r'^\s*$',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) =>
      EmptyLineRunnable(debug);
}
