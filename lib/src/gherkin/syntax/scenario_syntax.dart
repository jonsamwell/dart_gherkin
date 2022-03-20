import 'package:gherkin/src/gherkin/languages/dialect.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/syntax/regex_matched_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/scenario_outline_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/syntax_matcher.dart';
import 'package:gherkin/src/gherkin/syntax/tag_syntax.dart';

class ScenarioSyntax extends RegExMatchedGherkinSyntax<ScenarioRunnable> {
  @override
  RegExp pattern(GherkinDialect dialect) {
    final dialectPattern =
        RegExMatchedGherkinSyntax.getMultiDialectRegexPattern(dialect.scenario);

    return RegExp(
      '^\\s*(?:$dialectPattern):\\s*(.+)\\s*\$',
      multiLine: false,
      caseSensitive: false,
    );
  }

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      syntax is ScenarioSyntax ||
      syntax is ScenarioOutlineSyntax ||
      syntax is TagSyntax;

  @override
  ScenarioRunnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final name = pattern(dialect).firstMatch(line)!.group(1)!;
    final runnable = ScenarioRunnable(name, debug);

    return runnable;
  }
}
