import '../models/table_row.dart';

class Table {
  final Iterable<TableRow>? rows;
  final TableRow? header;

  Table(this.rows, this.header);

  void setStepParameter(String? parameterName, String value) {
    rows!.forEach((row) {
      row.setStepParameter(parameterName, value);
    });
  }

  /// Returns the table as a interable of maps.  With a single map representing a row in the table
  /// keyed by the column name if a header row is present else the column index (as a string)
  Iterable<Map<String?, String?>> asMap() {
    return <Map<String?, String?>>[
      ...rows!.map((row) {
        final map = <String?, String?>{};
        if (header != null) {
          for (var i = 0; i < header!.columns.length; i += 1) {
            map[header!.columns.toList().elementAt(i)] =
                row.columns.toList().length > i
                    ? row.columns.elementAt(i)
                    : null;
          }
        } else {
          for (var i = 0; i < row.columns.length; i += 1) {
            map[i.toString()] =
                row.columns.length > i ? row.columns.elementAt(i) : null;
          }
        }

        return map;
      })
    ];
  }

  Table clone() => Table(rows!.map((r) => r.clone()).toList(), header!.clone());
}
