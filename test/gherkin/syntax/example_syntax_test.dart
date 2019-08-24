import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/example.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/syntax/example_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = ExampleSyntax();
      expect(syntax.isMatch("Example:"), true);
      expect(syntax.isMatch("Examples:"), true);
      expect(syntax.isMatch("Example: "), true);
      expect(syntax.isMatch("Examples: "), true);
      expect(syntax.isMatch("Examples: something"), true);
      expect(syntax.isMatch(" Examples:   something"), true);
    });

    test('does not match', () {
      final syntax = ExampleSyntax();
      expect(syntax.isMatch("Example"), false);
      expect(syntax.isMatch("Examples"), false);
      expect(syntax.isMatch("Example something"), false);
      expect(syntax.isMatch("#Examples: something"), false);
    });
  });

  group("toRunnable", () {
    test('creates Runnable', () {
      final syntax = ExampleSyntax();
      final Runnable runnable = syntax.toRunnable(
          "Example: An example 123", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is ExampleRunnable));
      expect(runnable.name, equals("An example 123"));
    });

    test('creates Runnable with empty name', () {
      final syntax = ExampleSyntax();
      final Runnable runnable = syntax.toRunnable(
          "Examples:   ", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is ExampleRunnable));
      expect(runnable.name, equals(""));
    });

    test('creates Runnable with no name', () {
      final syntax = ExampleSyntax();
      final Runnable runnable = syntax.toRunnable(
          "Example:", RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is ExampleRunnable));
      expect(runnable.name, equals(""));
    });
  });
}
