import 'package:gherkin/src/gherkin/exceptions/syntax_error.dart';
import 'package:gherkin/src/gherkin/runnables/background.dart';
import 'package:gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/runnables/scenario.dart';
import 'package:gherkin/src/gherkin/runnables/scenario_outline.dart';
import 'package:gherkin/src/gherkin/runnables/taggable_runnable_block.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';
import 'package:gherkin/src/gherkin/runnables/text_line.dart';

class FeatureRunnable extends TaggableRunnableBlock {
  final String _name;
  String? description;
  final List<ScenarioRunnable> scenarios = <ScenarioRunnable>[];
  final List<TagsRunnable> _tagsPendingAssignmentToChild = <TagsRunnable>[];
  BackgroundRunnable? background;

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
        _tagsPendingAssignmentToChild.add(child as TagsRunnable);
        break;
      case ScenarioRunnable:
      case ScenarioOutlineRunnable:
        Iterable<ScenarioRunnable> childScenarios = [child as ScenarioRunnable];
        if (child is ScenarioOutlineRunnable) {
          childScenarios = child.expandOutlinesIntoScenarios();
        }

        scenarios.addAll(childScenarios);
        if (_tagsPendingAssignmentToChild.isNotEmpty) {
          for (final t in _tagsPendingAssignmentToChild) {
            childScenarios.forEach((s) => s.addTag(t));
          }
          _tagsPendingAssignmentToChild.clear();
        }

        break;
      case BackgroundRunnable:
        if (background == null) {
          background = child as BackgroundRunnable;
        } else {
          throw GherkinSyntaxException(
            'Feature file can only contain one background block. '
            "File'${debug.filePath}' :: line '${child.debug.lineNumber}'",
          );
        }
        break;
      case EmptyLineRunnable:
      case CommentLineRunnable:
        break;
      default:
        throw Exception(
          "Unknown runnable child given to Feature '${child.runtimeType}' - Line#${child.debug.lineText}: '${child.debug.lineText}'",
        );
    }
  }

  @override
  void onTagAdded(TagsRunnable tag) {
    for (final scenario in scenarios) {
      scenario.addTag(tag.clone(inherited: true));
    }
  }
}
