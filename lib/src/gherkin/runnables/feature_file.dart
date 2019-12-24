import 'package:gherkin/src/gherkin/runnables/taggable_runnable_block.dart';
import 'package:gherkin/src/gherkin/runnables/tags.dart';

import './debug_information.dart';
import './empty_line.dart';
import './feature.dart';
import './language.dart';
import './runnable.dart';
import './runnable_block.dart';

class FeatureFile extends RunnableBlock {
  String _language = 'en';
  final List<TagsRunnable> _tagsPendingAssignmentToChild = <TagsRunnable>[];

  List<FeatureRunnable> features = <FeatureRunnable>[];

  FeatureFile(RunnableDebugInformation debug) : super(debug);

  String get langauge => _language;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case LanguageRunnable:
        _language = (child as LanguageRunnable).language;
        break;
      case TagsRunnable:
        _tagsPendingAssignmentToChild.add(child);
        break;
      case FeatureRunnable:
        features.add(child);
        if (_tagsPendingAssignmentToChild.isNotEmpty) {
          _tagsPendingAssignmentToChild
              .forEach((t) => (child as TaggableRunnableBlock).addTag(t));
          _tagsPendingAssignmentToChild.clear();
        }
        break;
      case EmptyLineRunnable:
        break;
      default:
        throw Exception(
            "Unknown runnable child given to FeatureFile '${child.runtimeType}'");
    }
  }

  @override
  String get name => debug.filePath;
}
