import '../languages/dialect.dart';

import '../runnables/debug_information.dart';
import '../runnables/language.dart';
import 'regex_matched_syntax.dart';

/// see https://docs.cucumber.io/gherkin/reference/#gherkin-dialects
class LanguageSyntax extends RegExMatchedGherkinSyntax {
  @override
  RegExp pattern(GherkinDialect dialect) => RegExp(
        r'^\s*#\s*language:\s*([a-z-]{2,16})\s*$',
        multiLine: false,
        caseSensitive: false,
      );

  @override
  LanguageRunnable toRunnable(
    String line,
    RunnableDebugInformation debug,
    GherkinDialect dialect,
  ) {
    final runnable = LanguageRunnable(debug);
    runnable.language = pattern(dialect).firstMatch(line)!.group(1)!;

    return runnable;
  }
}
