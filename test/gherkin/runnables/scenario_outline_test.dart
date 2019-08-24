import 'package:gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/example.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_outline.dart';
import 'package:gherkin/src/gherkin/runnables/step.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group("addChild", () {
    test('can add EmptyLineRunnable', () {
      final runnable = ScenarioOutlineRunnable("", debugInfo);
      runnable.addChild(EmptyLineRunnable(debugInfo));
    });

    test('can add StepRunnable', () {
      final runnable = ScenarioOutlineRunnable("", debugInfo);
      runnable.addChild(StepRunnable("1", debugInfo));
      runnable.addChild(StepRunnable("2", debugInfo));
      runnable.addChild(StepRunnable("3", debugInfo));
      expect(runnable.steps.length, 3);
      expect(runnable.steps.elementAt(0).name, "1");
      expect(runnable.steps.elementAt(1).name, "2");
      expect(runnable.steps.elementAt(2).name, "3");
    });

    test('can add TagsRunnable', () {
      final runnable = ScenarioOutlineRunnable("", debugInfo);
      runnable.addChild(TagsRunnable(debugInfo)..tags = ["one", "two"]);
      runnable.addChild(TagsRunnable(debugInfo)..tags = ["three"]);
      expect(runnable.tags, ["one", "two", "three"]);
    });

    test('can add ExamplesRunnable', () {
      final runnable = ScenarioOutlineRunnable("", debugInfo);
      runnable.addChild(ExampleRunnable('', debugInfo));
      expect(runnable.examples, isNotNull);
    });

    test('can only add single ExamplesRunnable', () {
      final runnable = ScenarioOutlineRunnable('outline one', debugInfo);
      runnable.addChild(ExampleRunnable('1', debugInfo));
      expect(runnable.examples, isNotNull);

      expect(
          () => runnable.addChild(ExampleRunnable('2', debugInfo)),
          throwsA((e) =>
              e is GherkinSyntaxException &&
              e.message ==
                  "Scenerio outline `outline one` already contains an example block"));
    });
  });
}
