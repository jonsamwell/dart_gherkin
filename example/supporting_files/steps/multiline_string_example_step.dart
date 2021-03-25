import 'package:gherkin/gherkin.dart';

/// This step expects a multi-line string proceeding it
///
/// For example:
///
/// `Given I provide the following "review" comment`
///  """
///  Some comment
///  """
StepDefinitionGeneric GivenTheMultiLineComment() {
  return given2(
    'I provide the following {string} comment',
    (dynamic commentType, dynamic comment, _) async {
      // implement step
    },
  );
}
