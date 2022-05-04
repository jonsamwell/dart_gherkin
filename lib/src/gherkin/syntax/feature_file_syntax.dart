import '../languages/dialect.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import 'syntax_matcher.dart';

class FeatureFileSyntax extends SyntaxMatcher {
  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) => false;

  @override
  bool isMatch(String line, GherkinDialect dialect) {
    return false;
  }

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    throw UnimplementedError();
  }
}
