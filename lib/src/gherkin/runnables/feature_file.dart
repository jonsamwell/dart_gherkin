import 'package:gherkin/src/gherkin/runnables/comment_line.dart';
import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/feature.dart';
import 'package:gherkin/src/gherkin/runnables/language.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';
import 'package:gherkin/src/gherkin/runnables/runnable_block.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';

class FeatureFile extends RunnableBlock {
  String _language = 'en';
  final List<TagsRunnable> _tagsPendingAssignmentToChild = <TagsRunnable>[];

  List<FeatureRunnable> features = <FeatureRunnable>[];

  FeatureFile(RunnableDebugInformation debug) : super(debug);

  String get language => _language;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case LanguageRunnable:
        _language = (child as LanguageRunnable).language;
        break;
      case TagsRunnable:
        _tagsPendingAssignmentToChild.add(child as TagsRunnable);
        break;
      case FeatureRunnable:
        features.add(child as FeatureRunnable);
        if (_tagsPendingAssignmentToChild.isNotEmpty) {
          for (final tag in _tagsPendingAssignmentToChild) {
            child.addTag(tag);
          }
          _tagsPendingAssignmentToChild.clear();
        }
        break;
      case CommentLineRunnable:
      case EmptyLineRunnable:
        break;
      default:
        throw Exception(
          "Unknown runnable child given to FeatureFile '${child.runtimeType}'",
        );
    }
  }

  @override
  String get name => debug.filePath;
}
