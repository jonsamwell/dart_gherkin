import '../exceptions/syntax_error.dart';
import '../languages/dialect.dart';
import '../runnables/debug_information.dart';
import '../runnables/multi_line_string.dart';
import 'comment_syntax.dart';
import 'empty_line_syntax.dart';
import 'regex_matched_syntax.dart';
import 'syntax_matcher.dart';
import 'text_line_syntax.dart';

class MultilineStringSyntax
    extends RegExMatchedGherkinSyntax<MultilineStringRunnable> {
  @override
  RegExp pattern(GherkinDialect dialect) => RegExp(
        r'^\s*('
        '"""'
        r"|'''|```)\s*$",
        multiLine: false,
        caseSensitive: false,
      );

  @override
  bool get isBlockSyntax => true;

  @override
  bool hasBlockEnded(SyntaxMatcher syntax) {
    if (syntax is MultilineStringSyntax) {
      return true;
    } else if (!(syntax is TextLineSyntax ||
        syntax is CommentSyntax ||
        syntax is EmptyLineSyntax)) {
      throw GherkinSyntaxException(
        'Multiline string block does not expect ${syntax.runtimeType} syntax.  Expects a text line',
      );
    }
    return false;
  }

  @override
  MultilineStringRunnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final leadingWhitespace =
        RegExp(r'^(\s*)').firstMatch(line)?.group(1)?.length ?? 0;
    return MultilineStringRunnable(debug, leadingWhitespace: leadingWhitespace);
  }

  @override
  EndBlockHandling endBlockHandling(SyntaxMatcher syntax) =>
      syntax is MultilineStringSyntax
          ? EndBlockHandling.ignore
          : EndBlockHandling.continueProcessing;
}
