import '../exceptions/syntax_error.dart';
import './background.dart';
import './comment_line.dart';
import './debug_information.dart';
import './empty_line.dart';
import './runnable.dart';
import './runnable_block.dart';
import './scenario.dart';
import './tags.dart';
import './text_line.dart';

class FeatureRunnable extends RunnableBlock {
  String _name;
  String description;
  List<String> tags = <String>[];
  BackgroundRunnable background;
  List<ScenarioRunnable> scenarios = <ScenarioRunnable>[];

  Map<int, Iterable<String>> _tagMap = <int, Iterable<String>>{};

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
        tags.addAll((child as TagsRunnable).tags);
        _tagMap.putIfAbsent(
            child.debug.lineNumber, () => (child as TagsRunnable).tags);
        break;
      case ScenarioRunnable:
        scenarios.add(child);
        if (_tagMap.containsKey(child.debug.lineNumber - 1)) {
          (child as ScenarioRunnable).addChild(
              TagsRunnable(null)..tags = _tagMap[child.debug.lineNumber - 1]);
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
  }
}
