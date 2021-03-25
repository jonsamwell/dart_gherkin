import 'package:gherkin/src/gherkin/attachments/attachment.dart';

import '../gherkin/models/table.dart';
import '../gherkin/runnables/debug_information.dart';
import '../gherkin/steps/step_run_result.dart';

enum Target { run, feature, scenario, scenario_outline, step }

class Tag {
  final String name;
  final int lineNumber;
  final bool isInherited;

  int get nonZeroAdjustedLineNumber => lineNumber + 1;

  Tag(
    this.name,
    this.lineNumber, [
    this.isInherited = false,
  ]);
}

class StartedMessage {
  final Target target;
  final String? name;
  final RunnableDebugInformation context;
  final Iterable<Tag> tags;

  StartedMessage(
    this.target,
    this.name,
    this.context,
    this.tags,
  );
}

class FinishedMessage {
  final Target target;
  final String? name;
  final RunnableDebugInformation? context;

  FinishedMessage(this.target, this.name, this.context);
}

class StepStartedMessage extends StartedMessage {
  final Table? table;
  final String? multilineString;

  StepStartedMessage(
    String name,
    RunnableDebugInformation context, {
    this.table,
    this.multilineString,
  }) : super(
          Target.step,
          name,
          context,
          Iterable.empty(),
        );
}

class StepFinishedMessage extends FinishedMessage {
  final StepResult result;
  final Iterable<Attachment> attachments;

  StepFinishedMessage(
      String name, RunnableDebugInformation? context, this.result,
      [this.attachments = const Iterable<Attachment>.empty()])
      : super(Target.step, name, context);
}

class ScenarioFinishedMessage extends FinishedMessage {
  final bool passed;

  ScenarioFinishedMessage(
      String? name, RunnableDebugInformation? context, this.passed)
      : super(Target.scenario, name, context);
}
