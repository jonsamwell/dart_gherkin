import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/runnable.dart';

class TagsRunnable extends Runnable {
  late Iterable<String> tags;
  bool isInherited = false;

  @override
  String get name => 'Tags';

  TagsRunnable(RunnableDebugInformation debug) : super(debug);

  TagsRunnable clone({
    bool inherited = false,
  }) {
    return TagsRunnable(debug)
      ..tags = tags.map((t) => t).toList()
      ..isInherited = inherited;
  }
}
