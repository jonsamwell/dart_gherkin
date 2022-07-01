import '../exceptions/syntax_error.dart';
import 'debug_information.dart';
import 'example.dart';
import 'runnable.dart';
import 'scenario.dart';
import 'scenario_expanded_from_outline_example.dart';
import 'tags.dart';

class ScenarioOutlineRunnable extends ScenarioRunnable {
  final List<ExampleRunnable> _examples = <ExampleRunnable>[];
  TagsRunnable? _pendingExampleTags;
  Iterable<ExampleRunnable> get examples => _examples;

  ScenarioOutlineRunnable(
    String name,
    String? description,
    RunnableDebugInformation debug,
  ) : super(
          name,
          description,
          debug,
        );

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case ExampleRunnable:
        if (_pendingExampleTags != null) {
          (child as ExampleRunnable).addChild(_pendingExampleTags!);
          _pendingExampleTags = null;
        }

        _examples.add(child as ExampleRunnable);
        break;
      case TagsRunnable:
        _pendingExampleTags = child as TagsRunnable;
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
        'Scenario outline `$name` does not contains an example block.',
      );
    }

    final scenarios = <ScenarioRunnable>[];
    examples.forEach(
      (example) {
        example.table!.asMap().toList(growable: false).asMap().forEach(
          (exampleIndex, exampleRow) {
            final exampleName = [
              name,
              'Examples:',
              if (example.name.isNotEmpty) example.name,
              '(${exampleIndex + 1})',
            ].join(' ');

            final clonedSteps = steps.map((step) => step.clone()).toList();

            final scenarioRunnable = ScenarioExpandedFromOutlineExampleRunnable(
              exampleName,
              description,
              debug,
            );

            exampleRow.forEach(
              (parameterName, value) {
                scenarioRunnable.setStepParameter(parameterName, value ?? '');
                clonedSteps.forEach(
                  (step) => step.setStepParameter(parameterName, value ?? ''),
                );
              },
            );

            [...tags, ...example.tags]
                .forEach((t) => scenarioRunnable.addTag(t.clone()));

            clonedSteps.forEach((step) => scenarioRunnable.addChild(step));
            scenarios.add(scenarioRunnable);
          },
        );
      },
    );

    return scenarios;
  }
}
