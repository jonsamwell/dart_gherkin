import 'dart:io';

import 'package:gherkin/src/gherkin/languages/language_service.dart';
import 'package:glob/list_local_fs.dart';

import './configuration.dart';
import './feature_file_runner.dart';
import './gherkin/expressions/gherkin_expression.dart';
import './gherkin/expressions/tag_expression.dart';
import './gherkin/parameters/custom_parameter.dart';
import './gherkin/parameters/float_parameter.dart';
import './gherkin/parameters/int_parameter.dart';
import './gherkin/parameters/plural_parameter.dart';
import './gherkin/parameters/string_parameter.dart';
import './gherkin/parameters/word_parameter.dart';
import './gherkin/parser.dart';
import './gherkin/runnables/feature_file.dart';
import './gherkin/steps/exectuable_step.dart';
import './gherkin/steps/step_definition.dart';
import './hooks/aggregated_hook.dart';
import './hooks/hook.dart';
import './reporters/aggregated_reporter.dart';
import './reporters/message_level.dart';
import './reporters/reporter.dart';

class GherkinRunner {
  final _reporter = AggregatedReporter();
  final _hook = AggregatedHook();
  final _parser = GherkinParser();
  final _languageService = LanguageService();
  final _tagExpressionEvaluator = TagExpressionEvaluator();
  final List<ExecutableStep> _executableSteps = <ExecutableStep>[];
  final List<CustomParameter> _customParameters = <CustomParameter>[];

  Future<void> execute(TestConfiguration config) async {
    config.prepare();
    _registerReporters(config.reporters);
    _registerHooks(config.hooks);
    _registerCustomParameters(config.customStepParameterDefinitions);
    _registerStepDefinitions(config.stepDefinitions);
    _languageService.initialise(config.featureDefaultLanguage);

    var featureFiles = <FeatureFile>[];
    for (var glob in config.features) {
      for (var entity in glob.listSync()) {
        await _reporter.message("Found feature file '${entity.path}'", MessageLevel.verbose);
        final contents = File(entity.path).readAsStringSync();
        final featureFile = await _parser.parseFeatureFile(contents, entity.path, _reporter, _languageService);
        featureFiles.add(featureFile);
      }
    }

    var allFeaturesPassed = true;

    if (featureFiles.isEmpty) {
      await _reporter.message(
        'No feature files found to run, exiting without running any scenarios',
        MessageLevel.warning,
      );
    } else {
      await _reporter.message(
        'Found ${featureFiles.length} feature file(s) to run',
        MessageLevel.info,
      );

      if (config.order == ExecutionOrder.random) {
        await _reporter.message(
          'Executing features in random order',
          MessageLevel.info,
        );
        featureFiles = featureFiles.toList()..shuffle();
      }

      await _hook.onBeforeRun(config);

      try {
        await _reporter.onTestRunStarted();
        for (var featureFile in featureFiles) {
          final runner = FeatureFileRunner(
            config,
            _tagExpressionEvaluator,
            _executableSteps,
            _reporter,
            _hook,
          );
          allFeaturesPassed &= await runner.run(featureFile);
          if (config.exitAfterTestFailed && !allFeaturesPassed) {
            break;
          }
        }
      } finally {
        await _reporter.onTestRunFinished();
      }

      await _hook.onAfterRun(config);
    }

    await _reporter.dispose();
    exitCode = allFeaturesPassed ? 0 : 1;

    if (config.exitAfterTestRun) exit(allFeaturesPassed ? 0 : 1);
  }

  void _registerStepDefinitions(
    Iterable<StepDefinitionGeneric> stepDefinitions,
  ) {
    stepDefinitions.forEach(
      (s) {
        _executableSteps.add(
          ExecutableStep(GherkinExpression(s.pattern, _customParameters), s),
        );
      },
    );
  }

  void _registerCustomParameters(Iterable<CustomParameter>? customParameters) {
    _customParameters.add(FloatParameterLower());
    _customParameters.add(FloatParameterCamel());
    _customParameters.add(NumParameterLower());
    _customParameters.add(NumParameterCamel());
    _customParameters.add(IntParameterLower());
    _customParameters.add(IntParameterCamel());
    _customParameters.add(StringParameterLower());
    _customParameters.add(StringParameterCamel());
    _customParameters.add(WordParameterLower());
    _customParameters.add(WordParameterCamel());
    _customParameters.add(PluralParameter());
    if (customParameters != null) {
      _customParameters.addAll(customParameters);
    }
  }

  void _registerReporters(Iterable<Reporter>? reporters) {
    if (reporters != null) {
      reporters.forEach((r) => _reporter.addReporter(r));
    }
  }

  void _registerHooks(Iterable<Hook>? hooks) {
    if (hooks != null) {
      _hook.addHooks(hooks);
    }
  }
}
