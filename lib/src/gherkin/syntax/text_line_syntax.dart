import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/text_line.dart';
import './regex_matched_syntax.dart';

class TextLineSyntax extends RegExMatchedGherkinSyntax {
  @override

  /// Regex needs to make sure it does not match comment lines or empty whitespace lines
  RegExp pattern(GherkinDialect? dialect) => RegExp(
        r'^\s*(?!(\s*#\s*.+)|(\s+)).+$',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) {
    final runnable = TextLineRunnable(debug);
    runnable.originalText = line;
    runnable.text = line.trim();
    return runnable;
  }
}
