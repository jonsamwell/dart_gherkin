import './debug_information.dart';
import './runnable.dart';

class TagsRunnable extends Runnable {
  Iterable<String> tags;
  bool isInherited;

  @override
  String get name => "Tags";

  TagsRunnable(RunnableDebugInformation debug) : super(debug);

  TagsRunnable clone({
    bool isInheritedTag = false,
  }) {
    return TagsRunnable(debug)
      ..tags = tags.map((t) => t).toList()
      ..isInherited = isInheritedTag;
  }
}
