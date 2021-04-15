import 'package:gherkin/src/gherkin/languages/dialect.dart';

class FrDialectMock extends GherkinDialect {
  FrDialectMock() {
    name = 'French';
    when = ['* ', 'Quand ', 'Lorsque ', "Lorsqu'"];

    stepKeywords = (<String>[
      ...when,
    ]).toSet();
  }
}
