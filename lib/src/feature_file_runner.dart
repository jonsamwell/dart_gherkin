import 'dart:async';
import 'package:gherkin/src/gherkin/runnables/scenario_type_enum.dart';

import './reporters/message_level.dart';
import './hooks/hook.dart';
import './reporters/reporter.dart';
import './configuration.dart';
import './gherkin/exceptions/step_not_defined_error.dart';
import './gherkin/expressions/tag_expression.dart';
import './gherkin/runnables/background.dart';
import './gherkin/runnables/debug_information.dart';
import './gherkin/runnables/feature.dart';
import './gherkin/runnables/feature_file.dart';
import './gherkin/runnables/scenario.dart';
import './gherkin/runnables/step.dart';
import './gherkin/steps/exectuable_step.dart';
import './gherkin/steps/step_run_result.dart';
import './gherkin/steps/world.dart';
import './reporters/messages.dart';
import './gherkin/attachments/attachment_manager.dart';

class FeatureFileRunner {
  final TestConfiguration _config;
  final TagExpressionEvaluator _tagExpressionEvaluator;
  final Iterable<ExectuableStep> _steps;
  final Reporter _reporter;
  final Hook _hook;

  FeatureFileRunner(this._config, this._tagExpressionEvaluator, this._steps,
      this._reporter, this._hook);

  Future<bool> run(FeatureFile featureFile) async {
    bool haveAllFeaturesPassed = true;
    for (var feature in featureFile.features) {
      haveAllFeaturesPassed &= await _runFeature(feature);
    }

    return haveAllFeaturesPassed;
  }

  Future<bool> _runFeature(FeatureRunnable feature) async {
    bool haveAllScenariosPassed = true;
    try {
      await _reporter.onFeatureStarted(StartedMessage(
        Target.feature,
        feature.name,
        feature.debug,
        feature.tags.isNotEmpty
            ? feature.tags
                .map((t) => t.tags
                    .map((c) => Tag(c, t.debug.lineNumber, t.isInherited))
                    .toList())
                .reduce((a, b) => a..addAll(b))
                .toList()
            : Iterable<Tag>.empty().toList(),
      ));
      await _log("Attempting to running feature '${feature.name}'",
          feature.debug, MessageLevel.info);
      for (final scenario in feature.scenarios) {
        if (_canRunScenario(_config.tagExpression, scenario)) {
          haveAllScenariosPassed &=
              await _runScenario(scenario, feature.background);
        } else {
          await _log(
              "Ignoring scenario '${scenario.name}' as tag expression '${_config.tagExpression}' not satified",
              feature.debug,
              MessageLevel.info);
        }
      }
    } on Error catch (err) {
      await _log(
          "Fatal error encountered while running feature '${feature.name}'\n$err",
          feature.debug,
          MessageLevel.error);
      rethrow;
    } catch (e, stacktrace) {
      await _log("Error while running feature '${feature.name}'\n$e",
          feature.debug, MessageLevel.error);
      await _reporter.onException(e, stacktrace);
      rethrow;
    } finally {
      await _reporter.onFeatureFinished(
          FinishedMessage(Target.feature, feature.name, feature.debug));
      await _log("Finished running feature '${feature.name}'", feature.debug,
          MessageLevel.info);
    }

    return haveAllScenariosPassed;
  }

  bool _canRunScenario(String tagExpression, ScenarioRunnable scenario) {
    return tagExpression == null
        ? true
        : _tagExpressionEvaluator.evaluate(
            tagExpression,
            scenario.tags.isNotEmpty
                ? scenario.tags
                    .map((t) => t.tags.toList())
                    .reduce((a, b) => a..addAll(b))
                    .toList()
                : Iterable<String>.empty().toList(),
          );
  }

  Future<bool> _runScenario(
      ScenarioRunnable scenario, BackgroundRunnable background) async {
    final attachmentManager = await _config.getAttachmentManager(_config);
    World world;
    bool scenarioPassed = true;
    await _hook.onBeforeScenario(_config, scenario.name);

    if (_config.createWorld != null) {
      await _log("Creating new world for scenerio '${scenario.name}'",
          scenario.debug, MessageLevel.debug);
      world = await _config.createWorld(_config);
      world.setAttachmentManager(attachmentManager);
      await _hook.onAfterScenarioWorldCreated(world, scenario.name);
    }

    await _reporter.onScenarioStarted(StartedMessage(
      scenario.scenarioType == ScenarioType.scenario_outline
          ? Target.scenario_outline
          : Target.scenario,
      scenario.name,
      scenario.debug,
      scenario.tags.isNotEmpty
          ? scenario.tags
              .map((t) => t.tags
                  .map((tag) => Tag(tag, t.debug.lineNumber, t.isInherited))
                  .toList())
              .reduce((a, b) => a..addAll(b))
              .toList()
          : Iterable<Tag>.empty().toList(),
    ));
    if (background != null) {
      await _log("Running background steps for scenerio '${scenario.name}'",
          scenario.debug, MessageLevel.info);
      for (var step in background.steps) {
        final result =
            await _runStep(step, world, attachmentManager, !scenarioPassed);
        scenarioPassed = result.result == StepExecutionResult.pass;
        if (!_canContinueScenario(result)) {
          scenarioPassed = false;
          await _log(
              "Background step '${step.name}' did not pass, all remaining steps will be skiped",
              step.debug,
              MessageLevel.warning);
        }
      }
    }

    for (var step in scenario.steps) {
      final result =
          await _runStep(step, world, attachmentManager, !scenarioPassed);
      scenarioPassed = result.result == StepExecutionResult.pass;
      if (!_canContinueScenario(result)) {
        scenarioPassed = false;
        await _log(
            "Step '${step.name}' did not pass, all remaining steps will be skiped",
            step.debug,
            MessageLevel.warning);
      }
    }

    world?.dispose();

    await _reporter.onScenarioFinished(
        ScenarioFinishedMessage(scenario.name, scenario.debug, scenarioPassed));
    await _hook.onAfterScenario(_config, scenario.name);
    return scenarioPassed;
  }

  bool _canContinueScenario(StepResult stepResult) {
    return stepResult.result == StepExecutionResult.pass;
  }

  Future<StepResult> _runStep(StepRunnable step, World world,
      AttachmentManager attachmentManager, bool skipExecution) async {
    StepResult result;

    await _log(
        "Attempting to run step '${step.name}'", step.debug, MessageLevel.info);
    await _hook.onBeforeStep(world, step.name);
    await _reporter.onStepStarted(StepStartedMessage(
      step.name,
      step.debug,
      table: step.table,
      multilineString:
          step.multilineStrings.isNotEmpty ? step.multilineStrings.first : null,
    ));

    if (skipExecution) {
      result = StepResult(0, StepExecutionResult.skipped);
    } else {
      final ExectuableStep code = _matchStepToExectuableStep(step);
      final Iterable<dynamic> parameters = _getStepParameters(step, code);
      result = await _runWithinTest<StepResult>(
          step.name,
          () async => code.step
              .run(world, _reporter, _config.defaultTimeout, parameters));
    }

    await _hook.onAfterStep(world, step.name, result);
    await _reporter.onStepFinished(StepFinishedMessage(step.name, step.debug,
        result, attachmentManager?.getAttachementsForContext(step.name)));

    return result;
  }

  /// the idea here is that we could use this as an abstraction to run
  /// within another test framework
  Future<T> _runWithinTest<T>(String name, Future<T> fn()) async {
    // the timeout is handled indepedently from this
    final completer = Completer<T>();
    try {
      // test(name, () async {
      try {
        final result = await fn();
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
      // }, timeout: Timeout.none);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  ExectuableStep _matchStepToExectuableStep(StepRunnable step) {
    final executable = _steps.firstWhere(
        (s) => s.expression.isMatch(step.debug.lineText),
        orElse: () => null);
    if (executable == null) {
      final message = """
      Step definition not found for text:

        '${step.debug.lineText}'

      File path: ${step.debug.filePath}#${step.debug.lineNumber}
      Line:      ${step.debug.lineText}

      ---------------------------------------------

      You must implement the step like below and add the class to the 'stepDefinitions' property in your configuration:

      /// The 'Given' class can be replaced with 'Then', 'When' 'And' or 'But'
      /// All classes can take up to 5 input parameters anymore and you should probably us a table
      /// For example: `When4<String, bool, int, num>`
      /// You can also specify the type of world context you want
      /// `When4WithWorld<String, bool, int, num, MyWorld>`
      class Given_${step.debug.lineText.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')} extends Given1<String> {
        @override
        RegExp get pattern => RegExp(r"${step.debug.lineText}");

        @override
        Future<void> executeStep(String input1) async {
          // If the step is "Given I do a 'windy pop'"
          // in this example input1 would equal 'windy pop'

          // your code...
        }
      }
      """;
      _reporter.message(message, MessageLevel.error);
      throw GherkinStepNotDefinedException(message);
    }

    return executable;
  }

  Iterable<dynamic> _getStepParameters(StepRunnable step, ExectuableStep code) {
    Iterable<dynamic> parameters =
        code.expression.getParameters(step.debug.lineText);
    if (step.multilineStrings.isNotEmpty) {
      parameters = parameters.toList()..addAll(step.multilineStrings);
    }

    if (step.table != null) {
      parameters = parameters.toList()..add(step.table);
    }

    return parameters;
  }

  Future<void> _log(String message, RunnableDebugInformation context,
      MessageLevel level) async {
    await _reporter.message(
        "$message # ${context.filePath}:${context.lineNumber}", level);
  }
}
