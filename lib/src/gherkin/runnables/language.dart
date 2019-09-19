import 'package:gherkin/src/gherkin/langauges/dialect.dart';
import 'package:gherkin/src/gherkin/langauges/language_service.dart';

import './debug_information.dart';
import 'dialect_block.dart';

class LanguageRunnable extends DialectBlock {
  String language;

  @override
  String get name => "Language";

  LanguageRunnable(RunnableDebugInformation debug) : super(debug);

  @override
  GherkinDialect getDialect(LanguageService languageService) =>
      languageService.getDialect(language);
}
