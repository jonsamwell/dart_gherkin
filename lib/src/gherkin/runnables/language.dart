import 'package:gherkin/src/gherkin/languages/dialect.dart';
import 'package:gherkin/src/gherkin/languages/language_service.dart';

import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/dialect_block.dart';

class LanguageRunnable extends DialectBlock {
  late String language;

  @override
  String get name => 'Language';

  LanguageRunnable(RunnableDebugInformation debug) : super(debug);

  @override
  GherkinDialect getDialect(LanguageService languageService) =>
      languageService.getDialect(language);
}
