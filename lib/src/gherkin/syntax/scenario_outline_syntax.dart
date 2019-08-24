import '../runnables/scenario_outline.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import './regex_matched_syntax.dart';
import './syntax_matcher.dart';
import './tag_syntax.dart';

class ScenarioOutlineSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern = RegExp(r"^\s*Scenario Outline:(\s*(.+)\s*)?$",
      multiLine: false, caseSensitive: false);

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      syntax is ScenarioOutlineSyntax || syntax is TagSyntax;

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final name = pattern.firstMatch(line).group(1);
    final runnable = ScenarioOutlineRunnable(name?.trim(), debug);
    return runnable;
  }
}
