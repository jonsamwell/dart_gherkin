import 'package:gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/example.dart';
import 'package:gherkin/src/gherkin/runnables/table.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation.empty();

  group('addChild', () {
    test('can add TableRunnable', () {
      final runnable = ExampleRunnable('', debugInfo);
      runnable.addChild(TableRunnable(debugInfo));
    });

    test('can only add single TableRunnable', () {
      final runnable = ExampleRunnable('Example one', debugInfo);
      runnable.addChild(TableRunnable(debugInfo));
      expect(runnable.table, isNotNull);

      expect(
        () => runnable.addChild(TableRunnable(debugInfo)),
        throwsA(
          (e) =>
              e is GherkinSyntaxException &&
              e.message ==
                  "Only a single table can be added to the example 'Example one'",
        ),
      );
    });
  });
}
