import 'package:gherkin/src/gherkin/runnables/scenario_expanded_from_outline_example.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';

import '../exceptions/syntax_error.dart';
import '../runnables/example.dart';
import '../runnables/scenario.dart';
import './debug_information.dart';
import './runnable.dart';

class ScenarioOutlineRunnable extends ScenarioRunnable {
  final List<ExampleRunnable> _examples = <ExampleRunnable>[];
  Iterable<ExampleRunnable> get examples => _examples;
  TagsRunnable _pendingExampleTags;

  ScenarioOutlineRunnable(String name, RunnableDebugInformation debug)
      : super(name, debug);

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case ExampleRunnable:
        if (_pendingExampleTags != null) {
          (child as ExampleRunnable).addChild(_pendingExampleTags);
          _pendingExampleTags = null;
        }

        _examples.add(child);
        break;
      case TagsRunnable:
        _pendingExampleTags = child;
        break;
      default:
        super.addChild(child);
    }
  }

  @override
  void onTagAdded(TagsRunnable tag) {
    examples.forEach(
      (ex) {
        ex.addTag(tag.clone(inherited: true));
      },
    );
  }

  Iterable<ScenarioRunnable> expandOutlinesIntoScenarios() {
    if (examples.isEmpty) {
      throw GherkinSyntaxException(
          'Scenario outline `$name` does not contains an example block.');
    }

    final scenarios = <ScenarioRunnable>[];

    examples.forEach((example) {
      for (var exampleIndex = 0;
          exampleIndex < example.table.rows.length;
          exampleIndex += 1) {
        final exampleRow = example.table.rows.elementAt(exampleIndex);
        var exampleName = '$name Examples: ';
        if (example.name.isNotEmpty) {
          exampleName += example.name + ' ';
        }

        exampleName += '(${exampleIndex + 1})';

        final scenarioRunnable =
            ScenarioExpandedFromOutlineExampleRunnable(exampleName, debug);
        if (tags.isNotEmpty || example.tags.isNotEmpty) {
          [...tags, ...example.tags]
              .forEach((t) => scenarioRunnable.addTag(t.clone()));
        }

        final clonedSteps = steps.map((step) => step.clone()).toList();
        for (var i = 0; i < exampleRow.columns.length; i += 1) {
          final parameterName = example.table.header.columns.elementAt(i);
          final value = exampleRow.columns.elementAt(i);
          clonedSteps
              .forEach((step) => step.setStepParameter(parameterName, value));
        }

        clonedSteps.forEach((step) => scenarioRunnable.addChild(step));
        scenarios.add(scenarioRunnable);
      }
    });

    return scenarios;
  }
}
