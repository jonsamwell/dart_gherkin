import 'package:gherkin/src/gherkin/runnables/comment_line.dart';

import './debug_information.dart';
import './empty_line.dart';
import './runnable.dart';
import './runnable_block.dart';
import './text_line.dart';

class MultilineStringRunnable extends RunnableBlock {
  int? leadingWhitespace;

  List<String> lines = <String>[];

  @override
  String get name => 'Multiline String';

  MultilineStringRunnable(
    RunnableDebugInformation debug, {
    this.leadingWhitespace,
  }) : super(debug);

  @override
  void addChild(Runnable? child) {
    final exception = Exception(
        "Unknown runnable child given to Multiline string '${child.runtimeType}'");
    switch (child.runtimeType) {
      case TextLineRunnable:
        final text = (child as TextLineRunnable).originalText ??
            child.text!;
        lines.add(stripLeadingIndentation(text));
        break;
      case EmptyLineRunnable:
        lines.add('');
        break;
      case CommentLineRunnable:
        // at the moment we ignore comments in multiline strings - this seems standard behaviour in other gherkin implementations
        break;
      default:
        throw exception;
    }
  }

  /// Trim but retain intentional indentation
  String stripLeadingIndentation(String lineText) {
    if (lines.isEmpty && leadingWhitespace == null) {
      leadingWhitespace =
          RegExp(r'^(\s*)').firstMatch(lineText)?.group(1)?.length ?? 0;
    }

    return lineText.substring(leadingWhitespace ?? 0);
  }
}
