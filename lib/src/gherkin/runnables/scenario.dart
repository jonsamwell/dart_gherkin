import './comment_line.dart';
import './debug_information.dart';
import './empty_line.dart';
import './runnable.dart';
import './runnable_block.dart';
import './step.dart';
import './tags.dart';

class ScenarioRunnable extends RunnableBlock {
  String _name;
  List<String> tags = <String>[];
  List<StepRunnable> steps = <StepRunnable>[];

  ScenarioRunnable(this._name, RunnableDebugInformation debug) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case StepRunnable:
        steps.add(child);
        break;
      case TagsRunnable:
        tags.addAll((child as TagsRunnable).tags);
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
