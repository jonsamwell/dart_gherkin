import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/syntax/scenario_outline_syntax.dart';
import 'package:test/test.dart';

void main() {
  group("isMatch", () {
    test('matches correctly', () {
      final syntax = ScenarioOutlineSyntax();
      expect(syntax.isMatch("Scenario outline:"), true);
      expect(syntax.isMatch("Scenario outline:   "), true);
      expect(syntax.isMatch("Scenario outline: something"), true);
      expect(syntax.isMatch(" Scenario Outline:   something"), true);
    });

    test('does not match', () {
      final syntax = ScenarioOutlineSyntax();
      expect(syntax.isMatch("Scenario outline something"), false);
      expect(syntax.isMatch("#Scenario Outline: something"), false);
    });
  });

  group("toRunnable", () {
    test('creates FeatureRunnable', () {
      final keyword = ScenarioOutlineSyntax();
      final Runnable runnable = keyword.toRunnable(
          "Scenario Outline: A scenario outline 123",
          RunnableDebugInformation(null, 0, null));
      expect(runnable, isNotNull);
      expect(runnable, predicate((x) => x is ScenarioRunnable));
      expect(runnable.name, equals("A scenario outline 123"));
    });
  });
}
