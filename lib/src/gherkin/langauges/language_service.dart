import 'package:gherkin/src/gherkin/exceptions/dialect_not_supported.dart';

import 'dialect.dart';
import 'langauges.dart';

class LanguageService {
  String _defaultLangauge = 'en';
  Map<String, GherkinDialect> _dialects = {};

  String get defaultLanguage => _defaultLangauge;

  GherkinDialect getDialect([String langaugeCode]) {
    final code = langaugeCode ?? _defaultLangauge;

    if (_dialects[code] == null) {
      throw GherkinDialogNotSupportedException(code);
    }

    return _dialects[code];
  }

  void initialise([String defaultLanguage = 'en']) {
    _defaultLangauge = defaultLanguage;
    // final uri = Uri.file('dialects/langauges.json');
    // final langFile = File.fromUri(uri);
    // Map<String, dynamic> langaugesJson =
    //     json.decode(langFile.readAsStringSync());
    LANGUAGES_JSON.forEach((key, values) {
      final dialect = GherkinDialect.fromJSON(values)..languageCode = key;
      setDialect(key, dialect);
    });
  }

  void setDialect(String langaugeCode, GherkinDialect dialect) {
    _dialects[langaugeCode] = dialect;
  }
}
