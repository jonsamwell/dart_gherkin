import '../../gherkin/attachments/attachment.dart';
import '../../gherkin/models/table.dart';
import '../../gherkin/runnables/debug_information.dart';
import '../../gherkin/steps/step_run_result.dart';

part 'step/step_message.dart';
part 'scenario/scenario_message.dart';
part 'test/test_message.dart';
part 'feature/feature_message.dart';

enum Target {
  run,
  feature,
  scenario,
  scenarioOutline,
  step,
}

class Tag {
  final String name;
  final int lineNumber;
  final bool isInherited;

  int get nonZeroAdjustedLineNumber => lineNumber + 1;

  Tag(
    this.name,
    this.lineNumber, {
    this.isInherited = false,
  });
}

/// {@template messages.actionmessage}
/// A general message related to all kinds of entities in Gherkin tests
/// {@endtemplate}
class ActionMessage {
  /// Type of Gherkin entity
  final Target target;

  /// The ordinal name of the test, for example `Step 1`
  final String name;

  /// Message context in various test states
  final RunnableDebugInformation context;

  /// {@macro messages.actionmessage}
  const ActionMessage({
    required this.target,
    required this.name,
    required this.context,
  });
}
