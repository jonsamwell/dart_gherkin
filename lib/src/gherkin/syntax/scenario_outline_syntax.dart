import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../runnables/scenario_outline.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import './regex_matched_syntax.dart';
import './scenario_syntax.dart';
import './syntax_matcher.dart';

class ScenarioOutlineSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect? dialect) => RegExp(
        '^\\s*(?:${getMultiDialectRegexPattern(dialect!.scenarioOutline!)}):(?:\\s*(.+)\\s*)?\$',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      syntax is ScenarioOutlineSyntax || syntax is ScenarioSyntax;

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) {
    final name = pattern(dialect).firstMatch(line)!.group(1);
    final runnable = ScenarioOutlineRunnable(name?.trim(), debug);
    return runnable;
  }
}
