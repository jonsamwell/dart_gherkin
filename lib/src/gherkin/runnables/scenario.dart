import 'comment_line.dart';
import 'debug_information.dart';
import 'empty_line.dart';
import 'runnable.dart';
import 'scenario_type_enum.dart';
import 'step.dart';
import 'taggable_runnable_block.dart';
import 'text_line.dart';

class ScenarioRunnable extends TaggableRunnableBlock {
  final String _name;
  String? description;
  List<StepRunnable> steps = <StepRunnable>[];

  ScenarioType get scenarioType => ScenarioType.scenario;

  ScenarioRunnable(
    this._name,
    this.description,
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
      case TextLineRunnable:
        description = (child as TextLineRunnable).text;
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
