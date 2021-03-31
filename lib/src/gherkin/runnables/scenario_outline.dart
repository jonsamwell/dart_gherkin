import 'package:gherkin/src/gherkin/runnables/scenario_expanded_from_outline_example.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';

import '../exceptions/syntax_error.dart';
import '../runnables/example.dart';
import '../runnables/scenario.dart';
import './debug_information.dart';
import './runnable.dart';

class ScenarioOutlineRunnable extends ScenarioRunnable {
  final List<ExampleRunnable?> _examples = <ExampleRunnable?>[];
  Iterable<ExampleRunnable?> get examples => _examples;
  TagsRunnable? _pendingExampleTags;

  ScenarioOutlineRunnable(String? name, RunnableDebugInformation debug)
      : super(name, debug);

  @override
  void addChild(Runnable? child) {
    switch (child.runtimeType) {
      case ExampleRunnable:
        if (_pendingExampleTags != null) {
          (child as ExampleRunnable).addChild(_pendingExampleTags);
          _pendingExampleTags = null;
        }

        _examples.add(child as ExampleRunnable?);
        break;
      case TagsRunnable:
        _pendingExampleTags = child as TagsRunnable?;
        break;
      default:
        super.addChild(child);
    }
  }

  @override
  void onTagAdded(TagsRunnable? tag) {
    examples.forEach(
      (ex) {
        ex!.addTag(tag!.clone(inherited: true));
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
      example!.table!
          .asMap()
          .toList()
          .asMap()
          .forEach((exampleIndex, exampleRow) {
        var exampleName = [
          name,
          'Examples:',
          if (example.name.isNotEmpty) example.name,
          '(${exampleIndex + 1})',
        ].join(' ');
        final clonedSteps = steps.map((step) => step!.clone()).toList();

        final scenarioRunnable =
        ScenarioExpandedFromOutlineExampleRunnable(exampleName, debug);

        exampleRow.forEach((parameterName, value) {
          scenarioRunnable.setStepParameter(parameterName, value!);
          clonedSteps
              .forEach((step) => step.setStepParameter(parameterName, value));
        });

        [...tags, ...example.tags]
            .forEach((t) => scenarioRunnable.addTag(t!.clone()));

        clonedSteps.forEach((step) => scenarioRunnable.addChild(step));
        scenarios.add(scenarioRunnable);
      });
    });

    return scenarios;
  }
}
