import '../languages/dialect.dart';
import '../languages/language_service.dart';

import 'debug_information.dart';
import 'runnable.dart';

abstract class DialectBlock extends Runnable {
  DialectBlock(RunnableDebugInformation debug) : super(debug);

  GherkinDialect getDialect(LanguageService languageService);
}
