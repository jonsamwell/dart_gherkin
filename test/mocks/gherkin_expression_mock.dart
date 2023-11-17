import 'dart:async';

import 'package:gherkin/src/gherkin/expressions/gherkin_expression.dart';

typedef IsMatchFn = bool Function(String input);

class MockGherkinExpression implements GherkinExpression {
  final IsMatchFn isMatchFn;

  MockGherkinExpression(this.isMatchFn);

  @override
  FutureOr<Iterable> getParameters(String input) async =>
      const Iterable.empty();

  @override
  bool isMatch(String input) => isMatchFn(input);

  @override
  RegExp get originalExpression => RegExp('.');
}
