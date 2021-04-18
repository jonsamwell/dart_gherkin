import 'package:gherkin/src/gherkin/syntax/example_syntax.dart';
import 'package:gherkin/src/gherkin/syntax/tag_syntax.dart';

/// Tags are normally signals to terminate block capture but
/// example tags are special because they can be used within Scenario Outlines
/// even when another table with its own tags may be used within the same
/// scenario outline
class ExampleTagSyntax extends TagSyntax {
  @override
  bool hasBlockEnded(syntax) => syntax is ExampleSyntax;
}
