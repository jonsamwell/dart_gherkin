import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/gherkin/parser.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_outline.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';

class FeatureFileVisitor {
  Future<void> visit(
    String featureFileContents,
    String path,
    LanguageService languageService,
    Reporter reporter,
  ) async {
    final featureFile = await GherkinParser().parseFeatureFile(
      featureFileContents,
      path,
      reporter,
      languageService,
    );

    for (final feature in featureFile.features) {
      await visitFeature(
        feature.name,
        feature.description,
        _tagsToList(feature.tags),
      );

      for (var i = 0; i < feature.scenarios.length; i += 1) {
        final scenario = feature.scenarios.elementAt(i);
        final isFirst = i == 0;
        final isLast = i == (feature.scenarios.length - 1);
        final allScenarios = scenario is ScenarioOutlineRunnable
            ? scenario.expandOutlinesIntoScenarios()
            : [scenario];
        var acknowledgedScenarioPosition = false;

        for (var childScenario in allScenarios) {
          await visitScenario(
            childScenario.name,
            _tagsToList(childScenario.tags),
            acknowledgedScenarioPosition ? false : isFirst,
            acknowledgedScenarioPosition ? false : isLast,
          );

          acknowledgedScenarioPosition = true;

          if (feature.background != null) {
            final bg = feature.background;

            for (final step in bg!.steps) {
              await visitScenarioStep(
                step.name,
                step.multilineStrings,
                step.table,
              );
            }
          }

          for (final step in childScenario.steps) {
            await visitScenarioStep(
              step.name,
              step.multilineStrings,
              step.table,
            );
          }
        }
      }
    }

    return Future.value('');
  }

  Future<void> visitFeature(
    String name,
    String? description,
    Iterable<String> tags,
  ) async {}

  Future<void> visitScenario(
    String name,
    Iterable<String> tags,
    bool isFirst,
    bool isLast,
  ) async {}

  Future<void> visitScenarioStep(
    String name,
    Iterable<String> multiLineStrings,
    GherkinTable? table,
  ) async {}

  Iterable<String> _tagsToList(Iterable<TagsRunnable> tags) sync* {
    for (var tgs in tags) {
      for (var tag in tgs.tags) {
        yield tag;
      }
    }
  }
}
