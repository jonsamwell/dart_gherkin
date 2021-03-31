import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/empty_line.dart';
import '../runnables/runnable.dart';
import './regex_matched_syntax.dart';

class EmptyLineSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect? dialect) => RegExp(
        r'^\s*$',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) =>
      EmptyLineRunnable(debug);
}
