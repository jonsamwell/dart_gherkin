import 'package:gherkin/src/gherkin/runnables/scenario_expanded_from_outline_example.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';

import '../exceptions/syntax_error.dart';
import '../runnables/example.dart';
import '../runnables/scenario.dart';
import './debug_information.dart';
import './runnable.dart';

class ScenarioOutlineRunnable extends ScenarioRunnable {
  ExampleRunnable examples;

  ScenarioOutlineRunnable(String name, RunnableDebugInformation debug)
      : super(name, debug);

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case ExampleRunnable:
        if (examples != null) {
          throw new GherkinSyntaxException(
              'Scenerio outline `$name` already contains an example block');
        }

        examples = child;
        break;
      default:
        super.addChild(child);
    }
  }

  void onTagAdded(TagsRunnable tag) {
    examples?.addTag(tag.clone(inherited: true));
  }

  Iterable<ScenarioRunnable> expandOutlinesIntoScenarios() {
    if (examples == null) {
      throw new GherkinSyntaxException(
          'Scenerio outline `$name` does not contains an example block.');
    }

    final scenarios = List<ScenarioRunnable>();

    for (int exampleIndex = 0;
        exampleIndex < examples.table.rows.length;
        exampleIndex += 1) {
      final exampleRow = examples.table.rows.elementAt(exampleIndex);
      final scenarioRunnable = ScenarioExpandedFromOutlineExampleRunnable(
          '$name (Example ${exampleIndex + 1})'.trim(), this.debug);
      if (tags.isNotEmpty) {
        tags.map((t) => scenarioRunnable.addTag(t.clone()));
      }

      final clonedSteps = this.steps.map((step) => step.clone()).toList();
      for (int i = 0; i < exampleRow.columns.length; i += 1) {
        final parameterName = examples.table.header.columns.elementAt(i);
        final value = exampleRow.columns.elementAt(i);
        clonedSteps
            .forEach((step) => step.setStepParameter(parameterName, value));
      }

      clonedSteps.forEach((step) => scenarioRunnable.addChild(step));
      scenarios.add(scenarioRunnable);
    }

    return scenarios;
  }
}
