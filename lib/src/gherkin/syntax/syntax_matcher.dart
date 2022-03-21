import '../languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';

enum EndBlockHandling { ignore, continueProcessing }

abstract class SyntaxMatcher<TRunnable extends Runnable> {
  bool isMatch(String line, GherkinDialect dialect);
  bool get isBlockSyntax => false;
  bool hasBlockEnded(SyntaxMatcher syntax) => true;

  EndBlockHandling endBlockHandling(SyntaxMatcher syntax) =>
      EndBlockHandling.continueProcessing;

  TRunnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  );
}
