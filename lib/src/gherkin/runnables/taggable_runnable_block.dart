import 'debug_information.dart';
import 'runnable_block.dart';
import 'tags.dart';

abstract class TaggableRunnableBlock extends RunnableBlock {
  final List<TagsRunnable> _tags = <TagsRunnable>[];

  Iterable<TagsRunnable> get tags => _tags.toList()
    ..sort((a, b) => a.debug.lineNumber.compareTo(b.debug.lineNumber));

  TaggableRunnableBlock(RunnableDebugInformation debug) : super(debug);

  void addTag(TagsRunnable tag) {
    _tags.add(tag);
    onTagAdded(tag);
  }

  void onTagAdded(TagsRunnable tag) {}
}
