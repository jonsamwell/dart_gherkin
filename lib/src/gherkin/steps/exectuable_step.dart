import '../expressions/gherkin_expression.dart';
import './step_definition.dart';
import './world.dart';

class ExectuableStep {
  final GherkinExpression expression;
  final StepDefinitionGeneric<World> step;

  ExectuableStep(this.expression, this.step);
}
