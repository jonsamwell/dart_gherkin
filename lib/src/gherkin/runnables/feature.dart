import '../exceptions/syntax_error.dart';
import 'background.dart';
import 'comment_line.dart';
import 'debug_information.dart';
import 'empty_line.dart';
import 'runnable.dart';
import 'scenario.dart';
import 'scenario_outline.dart';
import 'taggable_runnable_block.dart';
import 'tags.dart';
import 'text_line.dart';

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
