import 'package:gherkin/gherkin.dart';

/// This step expects a multiline string proceeding it
///
/// For example:
///
/// `Given I add the users`
///  | Firstname | Surname | Age | Gender |
///  | Woody     | Johnson | 28  | Male   |
///  | Edith     | Summers | 23  | Female |
///  | Megan     | Hill    | 83  | Female |
class GivenIAddTheUsers extends Given1<Table> {
  @override
  Future<void> executeStep(Table dataTable) async {
    for (var row in dataTable.rows) {
      // do something with row
      row.columns.forEach((columnValue) => print(columnValue));
    }

    // or get the table as a map (column values keyed by the header)
    final columns = dataTable.asMap();
    final personOne = columns.elementAt(0);
    final personOneName = personOne["Firstname"];
    print('Name of first person: `$personOneName`');
  }

  @override
  RegExp get pattern => RegExp(r"I add the users");
}
