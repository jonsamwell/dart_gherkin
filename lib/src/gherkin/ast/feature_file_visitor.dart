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
        feature.scenarios.length,
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
            feature.name,
            _tagsToList(feature.tags),
            childScenario.name,
            _tagsToList(childScenario.tags),
            acknowledgedScenarioPosition ? false : isFirst,
            acknowledgedScenarioPosition ? false : isLast,
            path,
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

    return Future.value(null);
  }

  Future<void> visitFeature(
    String name,
    String? description,
    Iterable<String> tags,
    int childScenarioCount,
  ) async {}

  Future<void> visitScenario(
    String featureName,
    Iterable<String> featureTags,
    String name,
    Iterable<String> tags,
    bool isFirst,
    bool isLast,
    String path,
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
