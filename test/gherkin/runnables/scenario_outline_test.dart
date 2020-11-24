import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/example.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_outline.dart';
import 'package:gherkin/src/gherkin/runnables/step.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation(null, 0, null);
  group('addChild', () {
    test('can add EmptyLineRunnable', () {
      final runnable = ScenarioOutlineRunnable('', debugInfo);
      runnable.addChild(EmptyLineRunnable(debugInfo));
    });

    test('can add StepRunnable', () {
      final runnable = ScenarioOutlineRunnable('', debugInfo);
      runnable.addChild(StepRunnable('1', debugInfo));
      runnable.addChild(StepRunnable('2', debugInfo));
      runnable.addChild(StepRunnable('3', debugInfo));
      expect(runnable.steps.length, 3);
      expect(runnable.steps.elementAt(0).name, '1');
      expect(runnable.steps.elementAt(1).name, '2');
      expect(runnable.steps.elementAt(2).name, '3');
    });

    test('can add TagsRunnable which are give to the example', () {
      final runnable = ScenarioOutlineRunnable('', debugInfo);
      final example = ExampleRunnable('', debugInfo);
      runnable.addChild(example);
      runnable.addTag(TagsRunnable(debugInfo)..tags = ['one']);
      expect(example.tags.first.tags.first, 'one');
      expect(example.tags.first.isInherited, true);
    });

    test('can add ExamplesRunnable', () {
      final runnable = ScenarioOutlineRunnable('', debugInfo);
      runnable.addChild(ExampleRunnable('', debugInfo));
      expect(runnable.examples, isNotNull);
    });

    test('can add multiple ExamplesRunnable', () {
      final runnable = ScenarioOutlineRunnable('outline one', debugInfo);
      runnable.addChild(ExampleRunnable('1', debugInfo));
      runnable.addChild(ExampleRunnable('1', debugInfo));
      expect(runnable.examples, isNotNull);
      expect(runnable.examples.length, 2);
    });
  });
}
