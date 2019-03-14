import '../runnables/background.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import './empty_line_syntax.dart';
import './regex_matched_syntax.dart';
import './scenario_syntax.dart';
import './syntax_matcher.dart';
import './tag_syntax.dart';

class BackgroundSyntax extends RegExMatchedGherkinSyntax {
  @override
  final RegExp pattern = RegExp(r"^\s*Background:\s*(.+)\s*$",
      multiLine: false, caseSensitive: false);

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) =>
      syntax is ScenarioSyntax ||
      syntax is EmptyLineSyntax ||
      syntax is TagSyntax;

  @override
  Runnable toRunnable(String line, RunnableDebugInformation debug) {
    final name = pattern.firstMatch(line).group(1);
    final runnable = BackgroundRunnable(name, debug);

    return runnable;
  }
}
