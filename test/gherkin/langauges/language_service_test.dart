import 'package:gherkin/src/gherkin/languages/language_service.dart';
import 'package:test/test.dart';

void main() {
  group('service', () {
    test('can parse langauage json file', () async {
      final service = LanguageService();
      service.initialise();
    });

    test('can find default dialect', () async {
      final service = LanguageService();
      service.initialise();
      final dialect = service.getDialect();
      expect(dialect, isNotNull);
    });

    test('can find af dialect', () async {
      final service = LanguageService();
      service.initialise();
      final dialect = service.getDialect('af');
      expect(dialect, isNotNull);
    });

    test('can find en-au dialect', () async {
      final service = LanguageService();
      service.initialise();
      final dialect = service.getDialect('en-au');
      expect(dialect, isNotNull);
    });

    test('parses unicode correctly', () async {
      final service = LanguageService();
      service.initialise();
      final dialect = service.getDialect('zh-TW')!;
      expect(dialect, isNotNull);
      expect(dialect.nativeName, '繁體中文');
    });
  });
}
