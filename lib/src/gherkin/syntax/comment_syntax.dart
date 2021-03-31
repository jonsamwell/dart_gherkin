import 'package:gherkin/src/gherkin/languages/dialect.dart';

import '../runnables/comment_line.dart';
import '../runnables/debug_information.dart';
import '../runnables/runnable.dart';
import './regex_matched_syntax.dart';

class CommentSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect? dialect) => RegExp(
        '^#',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  Runnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect? dialect,
  ) =>
      CommentLineRunnable(line.trim(), debug);
}
