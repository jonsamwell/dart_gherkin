import '../expressions/gherkin_expression.dart';
import './step_definition.dart';
import './world.dart';

class ExecutableStep {
  final GherkinExpression expression;
  final StepDefinitionGeneric<World?> step;

  ExecutableStep(this.expression, this.step);
}
