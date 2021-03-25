import 'package:collection/collection.dart';
import 'package:gherkin/src/gherkin/languages/language_service.dart';
import 'package:gherkin/src/gherkin/runnables/dialect_block.dart';
import 'package:gherkin/src/gherkin/runnables/multi_line_string.dart';

import './exceptions/syntax_error.dart';
import './languages/dialect.dart';
import './runnables/debug_information.dart';
import './runnables/feature_file.dart';
import './runnables/runnable_block.dart';
import './syntax/background_syntax.dart';
import './syntax/comment_syntax.dart';
import './syntax/empty_line_syntax.dart';
import './syntax/example_syntax.dart';
import './syntax/feature_file_syntax.dart';
import './syntax/feature_syntax.dart';
import './syntax/language_syntax.dart';
import './syntax/multiline_string_syntax.dart';
import './syntax/scenario_outline_syntax.dart';
import './syntax/scenario_syntax.dart';
import './syntax/step_syntax.dart';
import './syntax/syntax_matcher.dart';
import './syntax/table_line_syntax.dart';
import './syntax/tag_syntax.dart';
import './syntax/text_line_syntax.dart';
import '../reporters/message_level.dart';
import '../reporters/reporter.dart';

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
    Reporter reporter,
    LanguageService languageService,
  ) async {
    final featureFile = FeatureFile(RunnableDebugInformation(path, 0, null));
    await reporter.message("Parsing feature file: '$path'", MessageLevel.debug);
    final lines = contents.trim().split(RegExp(r'(\r\n|\r|\n)', multiLine: true));
    try {
      _parseBlock(
        languageService,
        languageService.getDialect(),
        FeatureFileSyntax(),
        featureFile,
        lines,
        0,
        0,
      );
    } catch (e) {
      await reporter.message("Error while parsing feature file: '$path'\n$e", MessageLevel.error);
      rethrow;
    }

    return featureFile;
  }

  num _parseBlock(
    LanguageService languageService,
    GherkinDialect? dialect,
    SyntaxMatcher parentSyntaxBlock,
    RunnableBlock parentBlock,
    Iterable<String> lines,
    int lineNumber,
    int depth,
  ) {
    for (var i = lineNumber; i < lines.length; i += 1) {
      final line = lines.elementAt(i).trim();
      // print("$depth - $line");
      final matcher = syntaxMatchers.firstWhereOrNull((matcher) => matcher.isMatch(line, dialect));
      if (matcher != null) {
        if (parentSyntaxBlock.hasBlockEnded(matcher)) {
          switch (parentSyntaxBlock.endBlockHandling(matcher)) {
            case EndBlockHandling.ignore:
              return i;
            case EndBlockHandling.continueProcessing:
              return i - 1;
          }
        }

        final useUntrimmedLines = matcher is MultilineStringSyntax || parentBlock is MultilineStringRunnable;
        final runnable = matcher.toRunnable(
          useUntrimmedLines ? lines.elementAt(i) : line,
          parentBlock.debug.copyWith(i, line),
          dialect,
        );

        if (runnable is DialectBlock) {
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
            depth + 1,
          ) as int;
        }

        parentBlock.addChild(runnable);
      } else {
        throw GherkinSyntaxException("Unknown or un-implemented syntax: '$line', file: '${parentBlock.debug.filePath}");
      }
    }

    return lines.length;
  }
}
