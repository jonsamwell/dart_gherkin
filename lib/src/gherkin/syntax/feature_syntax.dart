import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import '../runnables/feature.dart';
import './syntax_matcher.dart';
import './regex_matched_syntax.dart';

class FeatureSyntax extends RegExMatchedGherkinSyntax {
  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) => false;

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) {
    final name = pattern(dialect).firstMatch(line)!.group(1);
    final runnable = FeatureRunnable(name, debug);
    return runnable;
  }

  @override
  RegExp pattern(GherkinDialect? dialect) => RegExp(
        '^(?:${getMultiDialectRegexPattern(dialect!.feature!)}):\\s*(.+)\\s*',
        multiLine: false,
        caseSensitive: false,
      );
}
