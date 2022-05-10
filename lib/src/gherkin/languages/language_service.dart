import '../exceptions/dialect_not_supported.dart';
import 'dialect.dart';
import 'languages.dart';

class LanguageService {
  String _defaultLanguage = 'en';
  final Map<String, GherkinDialect> _dialects = {};

  String get defaultLanguage => _defaultLanguage;

  GherkinDialect getDialect([
    String? languageCode,
  ]) {
    final code = languageCode ?? _defaultLanguage;

    if (_dialects[code] == null) {
      throw GherkinDialogNotSupportedException(code);
    }

    return _dialects[code]!;
  }

  void initialise([String defaultLanguage = 'en']) {
    _defaultLanguage = defaultLanguage;
    // final uri = Uri.file('dialects/languages.json');
    // final langFile = File.fromUri(uri);
    // Map<String, dynamic> languagesJson =
    //     json.decode(langFile.readAsStringSync());
    kLanguagesJson.forEach((key, values) {
      final dialect =
          GherkinDialect.fromJson(values as Map<String, dynamic>).copyWith(
        languageCode: key,
      );
      setDialect(key, dialect);
    });
  }

  void setDialect(String languageCode, GherkinDialect dialect) {
    _dialects[languageCode] = dialect;
  }
}
