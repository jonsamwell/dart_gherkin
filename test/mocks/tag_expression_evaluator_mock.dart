import 'package:gherkin/src/gherkin/expressions/tag_expression.dart';

class MockTagExpressionEvaluator implements TagExpressionEvaluator {
  @override
  bool evaluate(String tagExpression, List<String> tags) => true;
}
