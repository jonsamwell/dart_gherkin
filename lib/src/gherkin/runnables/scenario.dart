import 'package:gherkin/src/gherkin/runnables/taggable_runnable_block.dart';

import './comment_line.dart';
import './debug_information.dart';
import './empty_line.dart';
import './runnable.dart';
import './step.dart';

class ScenarioRunnable extends TaggableRunnableBlock {
  String _name;
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
      case CommentLineRunnable:
      case EmptyLineRunnable:
        break;
      default:
        throw Exception(
            "Unknown runnable child given to Scenario '${child.runtimeType}'");
    }
  }
}
