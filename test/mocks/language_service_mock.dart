import 'package:gherkin/gherkin.dart';

import 'en_dialect_mock.dart';

typedef OnStepFinished = void Function(StepMessage message);

class LanguageServiceMock extends LanguageService {
  String _defaultLangauge = 'en';
  @override
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
