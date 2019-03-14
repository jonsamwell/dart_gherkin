import './debug_information.dart';
import './empty_line.dart';
import './feature.dart';
import './language.dart';
import './runnable.dart';
import './runnable_block.dart';

class FeatureFile extends RunnableBlock {
  String _language = "en";

  List<FeatureRunnable> features = <FeatureRunnable>[];

  FeatureFile(RunnableDebugInformation debug) : super(debug);

  String get langauge => _language;

  @override
  void addChild(Runnable child) {
    switch (child.runtimeType) {
      case LanguageRunnable:
        _language = (child as LanguageRunnable).language;
        break;
      case FeatureRunnable:
        features.add(child);
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
