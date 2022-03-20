import 'package:gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_type_enum.dart';
import 'package:gherkin/src/gherkin/runnables/step.dart';
import 'package:gherkin/src/gherkin/runnables/taggable_runnable_block.dart';

class ScenarioRunnable extends TaggableRunnableBlock {
  final String _name;
  List<StepRunnable> steps = <StepRunnable>[];

  ScenarioType get scenarioType => ScenarioType.scenario;

  ScenarioRunnable(
    this._name,
    RunnableDebugInformation debug,
  ) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case StepRunnable:
        steps.add(child as StepRunnable);
        break;
      case CommentLineRunnable:
      case EmptyLineRunnable:
        break;
      default:
        throw Exception(
          "Unknown runnable child given to Scenario '${child.runtimeType}'",
        );
    }
  }
}
