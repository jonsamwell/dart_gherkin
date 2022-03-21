import 'package:collection/collection.dart';

import '../reporters/message_level.dart';
import '../reporters/reporter.dart';
import 'exceptions/syntax_error.dart';
import 'languages/dialect.dart';
import 'languages/language_service.dart';
import 'runnables/debug_information.dart';
import 'runnables/dialect_block.dart';
import 'runnables/feature_file.dart';
import 'runnables/multi_line_string.dart';
import 'runnables/runnable_block.dart';
import 'syntax/background_syntax.dart';
import 'syntax/comment_syntax.dart';
import 'syntax/empty_line_syntax.dart';
import 'syntax/example_syntax.dart';
import 'syntax/feature_file_syntax.dart';
import 'syntax/feature_syntax.dart';
import 'syntax/language_syntax.dart';
import 'syntax/multiline_string_syntax.dart';
import 'syntax/scenario_outline_syntax.dart';
import 'syntax/scenario_syntax.dart';
import 'syntax/step_syntax.dart';
import 'syntax/syntax_matcher.dart';
import 'syntax/table_line_syntax.dart';
import 'syntax/tag_syntax.dart';
import 'syntax/text_line_syntax.dart';

class GherkinParser {
  final Iterable<SyntaxMatcher> syntaxMatchers = [
    LanguageSyntax(),
    CommentSyntax(),
    FeatureSyntax(),
    BackgroundSyntax(),
    TagSyntax(),
    ScenarioOutlineSyntax(),
    ScenarioSyntax(),
    StepSyntax(),
    MultilineStringSyntax(),
    EmptyLineSyntax(),
    TableLineSyntax(),
    ExampleSyntax(),
    TextLineSyntax(),
  ];

  Future<FeatureFile> parseFeatureFile(
    String contents,
    String path,
    MessageReporter reporter,
    LanguageService languageService,
  ) async {
    final featureFile = FeatureFile(
      RunnableDebugInformation(
        path,
        0,
        '',
      ),
    );
    await reporter.message(
      "Parsing feature file: '$path'",
      MessageLevel.debug,
    );
    final lines = contents.trim().split(
          RegExp(r'(\r\n|\r|\n)', multiLine: true),
        );

    try {
      _parseBlock(
        languageService,
        languageService.getDialect(),
        FeatureFileSyntax(),
        featureFile,
        lines,
        0,
      );
    } catch (e) {
      await reporter.message(
        "Error while parsing feature file: '$path'\n$e",
        MessageLevel.error,
      );

      rethrow;
    }

    return featureFile;
  }

  int _parseBlock(
    LanguageService languageService,
    GherkinDialect dialect,
    SyntaxMatcher parentSyntaxBlock,
    RunnableBlock parentBlock,
    Iterable<String> lines,
    int lineNumber,
  ) {
    for (var i = lineNumber; i < lines.length; i += 1) {
      final line = lines.elementAt(i).trim();
      // print("$line");
      final matcher = syntaxMatchers.firstWhereOrNull(
        (matcher) => matcher.isMatch(line, dialect),
      );

      /// Tags are unique because they rely on the next immediate line.
      /// Other matchers care about what comes before but never after.
      ///
      /// This is a subpar solution and would be a good candidate to refactor
      if (matcher is TagSyntax) {
        matcher.annotating =
            TagSyntax.determineAnnotationBlock(lines.elementAt(i + 1), dialect);
      }

      if (matcher != null) {
        // end look ahead here???
        if (parentSyntaxBlock.hasBlockEnded(matcher)) {
          switch (parentSyntaxBlock.endBlockHandling(matcher)) {
            case EndBlockHandling.ignore:
              return i;
            case EndBlockHandling.continueProcessing:
              return i - 1;
          }
        }

        final useUntrimmedLines = matcher is MultilineStringSyntax ||
            parentBlock is MultilineStringRunnable;
        final runnable = matcher.toRunnable(
          useUntrimmedLines ? lines.elementAt(i) : line,
          parentBlock.debug.copyWith(lineNumber: i, lineText: line),
          dialect,
        );

        if (runnable is DialectBlock) {
          // ignore: parameter_assignments
          dialect = runnable.getDialect(languageService);
        }

        if (runnable is RunnableBlock) {
          i = _parseBlock(
            languageService,
            dialect,
            matcher,
            runnable,
            lines,
            i + 1,
          );
        }

        parentBlock.addChild(runnable);
      } else {
        throw GherkinSyntaxException(
          "Unknown or un-implemented syntax: '$line', file: '${parentBlock.debug.filePath}",
        );
      }
    }

    return lines.length;
  }
}
