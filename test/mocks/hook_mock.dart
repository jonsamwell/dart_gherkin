import 'package:gherkin/gherkin.dart';

typedef OnBeforeRunCode = void Function();

class HookMock extends Hook {
  int onBeforeRunInvocationCount = 0;
  int onAfterRunInvocationCount = 0;
  int onBeforeScenarioInvocationCount = 0;
  int onBeforeStepInvocationCount = 0;
  int onAfterScenarioInvocationCount = 0;
  int onAfterScenarioWorldCreatedInvocationCount = 0;
  int onAfterStepInvocationCount = 0;
  List<Tag>? onBeforeScenarioTags;
  late List<Tag> onAfterScenarioTags;

  final int providedPriority;
  final OnBeforeRunCode? onBeforeRunCode;

  @override
  int get priority => providedPriority;

  HookMock({this.onBeforeRunCode, this.providedPriority = 0});

  @override
  Future<void> onBeforeRun(TestConfiguration? config) async {
    onBeforeRunInvocationCount += 1;
    if (onBeforeRunCode != null) {
      onBeforeRunCode!();
    }
  }

  @override
  Future<void> onAfterRun(TestConfiguration? config) async => onAfterRunInvocationCount += 1;

  @override
  Future<void> onBeforeScenario(
    TestConfiguration? config,
    String? scenario,
    Iterable<Tag>? tags,
  ) async {
    onBeforeScenarioTags = tags?.toList();
    onBeforeScenarioInvocationCount += 1;
  }

  @override
  Future<void> onBeforeStep(World? world, String? step) async => onBeforeStepInvocationCount += 1;

  @override
  Future<void> onAfterScenario(
    TestConfiguration config,
    String? scenario,
    Iterable<Tag> tags,
  ) async {
    onAfterScenarioTags = tags.toList();
    onAfterScenarioInvocationCount += 1;
  }

  @override
  Future<void> onAfterScenarioWorldCreated(
    World? world,
    String? scenario,
    Iterable<Tag>? tags,
  ) async =>
      onAfterScenarioWorldCreatedInvocationCount += 1;

  @override
  Future<void> onAfterStep(World? world, String? step, StepResult? result) async => onAfterStepInvocationCount += 1;
}
