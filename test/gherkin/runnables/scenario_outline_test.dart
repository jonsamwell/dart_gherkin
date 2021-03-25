import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/example.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_outline.dart';
import 'package:gherkin/src/gherkin/runnables/step.dart';
import 'package:gherkin/src/gherkin/runnables/table.dart';
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
      expect(runnable.steps.elementAt(0)!.name, '1');
      expect(runnable.steps.elementAt(1)!.name, '2');
      expect(runnable.steps.elementAt(2)!.name, '3');
    });

    test('can add TagsRunnable which are give to the example', () {
      final runnable = ScenarioOutlineRunnable('', debugInfo);
      final example = ExampleRunnable('', debugInfo);
      runnable.addChild(example);
      runnable.addTag(TagsRunnable(debugInfo)..tags = ['one']);
      expect(example.tags.first!.tags!.first, 'one');
      expect(example.tags.first!.isInherited, true);
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

    test('can interpolate variables in the scenario name', () {
      final runnable = ScenarioOutlineRunnable('Scenario outline with parameters: <i>, <k>', debugInfo);
      final example = ExampleRunnable('', debugInfo);
      final exampleTable = TableRunnable(debugInfo);

      exampleTable.rows..add('| i    | j   | k     |')..add('| 1    | 2   | 3     |')..add('| text | 4.5 | false |');
      example.addChild(exampleTable);
      runnable.addChild(example);

      final expandedScenarios = runnable.expandOutlinesIntoScenarios();
      final expandedScenario1 = expandedScenarios.elementAt(0);
      final expandedScenario2 = expandedScenarios.elementAt(1);

      expect(expandedScenario1.name, equals('Scenario outline with parameters: 1, 3 Examples: (1)'));
      expect(expandedScenario2.name, equals('Scenario outline with parameters: text, false Examples: (2)'));
    });
  });
}
