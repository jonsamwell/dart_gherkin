import './comment_line.dart';
import './debug_information.dart';
import './empty_line.dart';
import './runnable.dart';
import './step.dart';
import 'scenario_type_enum.dart';
import 'taggable_runnable_block.dart';

class ScenarioRunnable extends TaggableRunnableBlock {
  final String? _name;
  List<StepRunnable?> steps = <StepRunnable?>[];

  ScenarioType get scenarioType => ScenarioType.scenario;

  ScenarioRunnable(
    this._name,
    RunnableDebugInformation debug,
  ) : super(debug);

  @override
  String? get name => _name;

  @override
  void addChild(Runnable? child) {
    switch (child.runtimeType) {
      case StepRunnable:
        steps.add(child as StepRunnable?);
        break;
      case CommentLineRunnable:
      case EmptyLineRunnable:
        break;
      default:
        throw Exception(
            "Unknown runnable child given to Scenario '${child.runtimeType}'");
    }
  }
}
