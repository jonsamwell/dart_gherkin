import 'package:gherkin/src/gherkin/expressions/gherkin_expression.dart';
import 'package:gherkin/src/gherkin/steps/step_definition.dart';
import 'package:gherkin/src/gherkin/steps/world.dart';

class ExecutableStep {
  final GherkinExpression expression;
  final StepDefinitionGeneric<World> step;

  ExecutableStep(this.expression, this.step);
}
