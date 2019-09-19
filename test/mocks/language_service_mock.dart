import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/gherkin/langauges/language_service.dart';

import 'en_dialect_mock.dart';

typedef void OnStepFinished(StepFinishedMessage message);

class LanguageServiceMock extends LanguageService {
  String _defaultLangauge = 'en';
  String get defaultLanguage => _defaultLangauge;

  LanguageServiceMock() : super() {
    initialise();
  }

  @override
  void initialise([String defaultLanguage = 'en']) {
    _defaultLangauge = defaultLanguage;
    setDialect('en', EnDialectMock());
  }
}
