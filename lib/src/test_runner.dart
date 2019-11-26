import 'dart:io';
import 'dart:isolate';
import 'dart:mirrors';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin/src/gherkin/langauges/language_service.dart';
import 'package:gherkin/src/utils/step_instance_creator.dart';
import 'package:glob/glob.dart';

import './configuration.dart';
import './feature_file_runner.dart';
import './gherkin/expressions/gherkin_expression.dart';
import './gherkin/expressions/tag_expression.dart';
import './gherkin/parameters/custom_parameter.dart';
import './gherkin/parameters/plural_parameter.dart';
import './gherkin/parameters/word_parameter.dart';
import './gherkin/parameters/string_parameter.dart';
import './gherkin/parameters/int_parameter.dart';
import './gherkin/parameters/float_parameter.dart';
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
  final _langaugeService = LanguageService();
  final _tagExpressionEvaluator = TagExpressionEvaluator();
  final List<ExectuableStep> _executableSteps = <ExectuableStep>[];
  final List<CustomParameter> _customParameters = <CustomParameter>[];

  Future<void> execute(TestConfiguration config) async {
    config.prepare();
    _registerReporters(config.reporters);
    _registerHooks(config.hooks);
    _registerCustomParameters(config.customStepParameterDefinitions);
    await _registerStepDefinitions(config.stepDefinitions);
    _langaugeService.initialise(config.featureDefaultLanguage);

    List<FeatureFile> featureFiles = <FeatureFile>[];
    for (var glob in config.features) {
      for (var entity in glob.listSync()) {
        await _reporter.message(
            "Found feature file '${entity.path}'", MessageLevel.verbose);
        final contents = File(entity.path).readAsStringSync();
        final featureFile = await _parser.parseFeatureFile(
            contents, entity.path, _reporter, _langaugeService);
        featureFiles.add(featureFile);
      }
    }

    bool allFeaturesPassed = true;

    if (featureFiles.isEmpty) {
      await _reporter.message(
          "No feature files found to run, exitting without running any scenarios",
          MessageLevel.warning);
    } else {
      await _reporter.message(
          "Found ${featureFiles.length} feature file(s) to run",
          MessageLevel.info);

      if (config.order == ExecutionOrder.random) {
        await _reporter.message(
            "Executing features in random order", MessageLevel.info);
        featureFiles = featureFiles.toList()..shuffle();
      }

      await _hook.onBeforeRun(config);

      try {
        await _reporter.onTestRunStarted();
        for (var featureFile in featureFiles) {
          final runner = FeatureFileRunner(config, _tagExpressionEvaluator,
              _executableSteps, _reporter, _hook);
          allFeaturesPassed &= await runner.run(featureFile);
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

  Future<void> _registerStepDefinitions(
      Iterable<StepDefinitionGeneric> stepDefinitions) async {
    var definitions = stepDefinitions;
    if (stepDefinitions == null || stepDefinitions.isEmpty) {
      definitions = await findAllStepDefinitions();
    }

    definitions.forEach((s) {
      _executableSteps.add(
          ExectuableStep(GherkinExpression(s.pattern, _customParameters), s));
    });
  }

  void _registerCustomParameters(Iterable<CustomParameter> customParameters) {
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
    if (customParameters != null) _customParameters.addAll(customParameters);
  }

  void _registerReporters(Iterable<Reporter> reporters) {
    if (reporters != null) {
      reporters.forEach((r) => _reporter.addReporter(r));
    }
  }

  void _registerHooks(Iterable<Hook> hooks) {
    if (hooks != null) {
      _hook.addHooks(hooks);
    }
  }

  Future<Iterable<StepDefinitionGeneric>> findAllStepDefinitions() async {
    final foundSteps = List<ClassMirror>();
    final stepInstances = List<StepDefinitionGeneric>();
    MirrorSystem mirrorSystem = currentMirrorSystem();
    final searchableLibraries =
        mirrorSystem.libraries.entries.where((libEntry) {
      final name = libEntry.value.simpleName.toString();
      Iterable<Pattern> patterns = [
        'gherkin',
        'meta',
        'nativewrappers',
        RegExp('dart(?:\.|:).*')
      ];
      final found = patterns.firstWhere((pattern) => name.contains(pattern),
          orElse: () => null);
      if (found != null) {
        print(
            'Ignoring lib `${name}` as it matches the blacklist libraries pattern `$found`');
      }

      return found == null;
    }).toList();

    print('Searching ${searchableLibraries.length} libs for step classes...');
    for (var lib in searchableLibraries) {
      for (var declaration in lib.value.declarations.entries) {
        final klass = declaration.value;
        if (klass is ClassMirror && !klass.isAbstract) {
          if (klass.isSubclassOf(reflectClass(StepDefinitionGeneric))) {
            print('Found step `${lib.value.qualifiedName}`::`${klass.qualifiedName.toString()}`');
            foundSteps.add(klass);
          }
        }
      }
    }

    for (var step in foundSteps) {
      final instance =
          await StepDefinitionInstanceCreator().createInstance(step);
      stepInstances.add(instance);
    }

    String fileContents = """
    import "dart:isolate";
    import 'supporting_files/steps/given_the_characters.step.dart';

    void main(_, SendPort port) {
      print('START');
      final step = GivenTheCharacters();
      // print('MIDDLE');
      // step.executeStep('A');
      // print('DONE');
    }
    """;

    // for (var glob in [Glob(r'**step.dart')]) {
    //   for (var stepFile in glob.listSync()) {
    //     print(stepFile.path);
    //   }
    // }

    // final process = await Process.start(
    //   "dart",
    //   ['tempfile.dart'],
    //   workingDirectory: "./",
    //   runInShell: false,
    // );

    // await stdout.addStream(process.stdout);
    // await stderr.addStream(process.stderr);

    // await process.exitCode;

    // https://stackoverflow.com/questions/13585082/how-do-i-execute-dynamically-like-eval-in-dart
    // final name = 'Eval Knievel';
    // final uri = Uri.dataFromString(
    //   '''
    // import "dart:isolate";

    // void main(_, SendPort port) {
    //   print('MOOO');
    //   port.send("Nice to meet you, $name!");
    // }
    // ''',
    //   mimeType: 'application/dart',
    // );

    // final port = ReceivePort();
    // await Isolate.spawnUri(uri, [], port.sendPort);

    // final String response = await port.first;
    // print(response);

    final newUri = Uri.dataFromString(
      fileContents,
      mimeType: 'application/dart',
    );
    final port1 = ReceivePort();
    final iso = await Isolate.spawnUri(
      Uri.parse('../example/tempfile.dart'),
      [],
      port1.sendPort,
      onError: port1.sendPort,
      debugName: 'MOOOO',
      errorsAreFatal: true,
      packageConfig: Uri.directory('./'),
    );
    print(await port1.first);

    return stepInstances;
  }
}
