import 'package:gherkin/src/gherkin/runnables/debug_information.dart';
import 'package:gherkin/src/gherkin/runnables/empty_line.dart';
import 'package:gherkin/src/gherkin/runnables/multi_line_string.dart';
import 'package:gherkin/src/gherkin/runnables/text_line.dart';
import 'package:test/test.dart';

void main() {
  final debugInfo = RunnableDebugInformation('', 0, null);
  group('addChild', () {
    test('can add EmptyLineRunnable', () {
      final runnable = MultilineStringRunnable(debugInfo);
      runnable.addChild(EmptyLineRunnable(debugInfo));
    });
    test('can add TextLineRunnable', () {
      final runnable = MultilineStringRunnable(debugInfo);
      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '1');
      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '2');
      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '3');
      expect(runnable.lines.length, 3);
      expect(runnable.lines, ['1', '2', '3']);
    });
  });

  group('stripLeadingIndentation', () {
    test('preserve original indentation from the first line', () {
      final runnable = MultilineStringRunnable(debugInfo);

      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '   1');
      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '    2');
      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '    3');
      expect(runnable.lines.length, 3);
      expect(runnable.lines, ['1', ' 2', ' 3']);
    });

    test('preserve original indentation from a specified position', () {
      final runnable = MultilineStringRunnable(debugInfo, leadingWhitespace: 4);

      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '       1');
      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '      2');
      runnable.addChild(TextLineRunnable(debugInfo)..originalText = '     3');
      expect(runnable.lines.length, 3);
      expect(runnable.lines, ['   1', '  2', ' 3']);
    });
  });
}
