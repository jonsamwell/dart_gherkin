import 'package:gherkin/src/gherkin/runnables/taggable_runnable_block.dart';

import '../exceptions/syntax_error.dart';
import './background.dart';
import './comment_line.dart';
import './debug_information.dart';
import './empty_line.dart';
import './runnable.dart';
import './scenario.dart';
import './scenario_outline.dart';
import './tags.dart';
import './text_line.dart';

class FeatureRunnable extends TaggableRunnableBlock {
  String _name;
  String description;
  BackgroundRunnable background;
  List<ScenarioRunnable> scenarios = <ScenarioRunnable>[];
  List<TagsRunnable> _tagsPendingAssignmentToChild = List<TagsRunnable>();

  FeatureRunnable(this._name, RunnableDebugInformation debug) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case TextLineRunnable:
        description =
            "${description == null ? "" : "$description\n"}${(child as TextLineRunnable).text}";
        break;
      case TagsRunnable:
        _tagsPendingAssignmentToChild.add(child);
        break;
      case ScenarioRunnable:
      case ScenarioOutlineRunnable:
        Iterable<ScenarioRunnable> childScenarios = [child];
        if (child is ScenarioOutlineRunnable) {
          childScenarios = child.expandOutlinesIntoScenarios();
        }

        scenarios.addAll(childScenarios);
        if (_tagsPendingAssignmentToChild.isNotEmpty) {
          _tagsPendingAssignmentToChild
              .forEach((t) => childScenarios.forEach((s) => s.addTag(t)));
          _tagsPendingAssignmentToChild.clear();
        }

        break;
      case BackgroundRunnable:
        if (background == null) {
          background = child;
        } else {
          throw GherkinSyntaxException(
              "Feature file can only contain one backgroung block. File'${debug.filePath}' :: line '${child.debug.lineNumber}'");
        }
        break;
      case EmptyLineRunnable:
      case CommentLineRunnable:
        break;
      default:
        throw Exception(
            "Unknown runnable child given to Feature '${child.runtimeType}' - Line#${child.debug.lineText}: '${child.debug.lineText}'");
    }

    // if (child is TaggableRunnableBlock && !(child is BackgroundRunnable)) {
    //   if (tags.isNotEmpty) {
    //     tags.forEach((t) => child.addTag(t));
    //   }

    //   if (_tagsPendingAssignmentToChild.isNotEmpty) {
    //     _tagsPendingAssignmentToChild.forEach((t) => child.addTag(t));
    //     _tagsPendingAssignmentToChild.clear();
    //   }
    // }
  }

  void onTagAdded(TagsRunnable tag) {
    for (var scenario in scenarios) {
      scenario.addTag(tag.clone(isInheritedTag: true));
    }
  }
}
