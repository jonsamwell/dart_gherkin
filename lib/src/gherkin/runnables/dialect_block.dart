import 'package:gherkin/src/gherkin/languages/dialect.dart';
import 'package:gherkin/src/gherkin/languages/language_service.dart';

import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';

abstract class DialectBlock extends Runnable {
  DialectBlock(RunnableDebugInformation debug) : super(debug);

  GherkinDialect getDialect(LanguageService languageService);
}
