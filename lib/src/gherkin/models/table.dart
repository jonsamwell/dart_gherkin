import 'dart:convert';

import 'table_row.dart';

class GherkinTable {
  final Iterable<TableRow> rows;
  final TableRow? header;

  GherkinTable(
    this.rows,
    this.header,
  );

  void setStepParameter(
    String parameterName,
    String value,
  ) {
    for (final row in rows) {
      row.setStepParameter(parameterName, value);
    }
  }

  /// Returns the table as a iterable of maps.  With a single map representing a row in the table
  /// keyed by the column name if a header row is present else the column index (as a string)
  Iterable<Map<String, String?>> asMap() {
    return <Map<String, String?>>[
      ...rows.map(
        (row) {
          final map = <String, String?>{};
          if (header != null) {
            for (var i = 0; i < header!.columns.length; i += 1) {
              map[header!.columns.toList().elementAt(i)!] =
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
        },
      )
    ];
  }

  String toJson() => jsonEncode(asMap());

  factory GherkinTable.fromJson(String json) {
    final data = (jsonDecode(json) as List<dynamic>)
        .map((x) => x as Map<String, dynamic>);
    final headerRow = data.isNotEmpty
        ? TableRow(data.first.keys, 1, isHeaderRow: true)
        : null;
    final rows = data
        .map((x) => TableRow(x.values.cast<String?>(), 1, isHeaderRow: false));
    final table = GherkinTable(rows, headerRow);

    return table;
  }

  GherkinTable clone() => GherkinTable(
        rows.map((r) => r.clone()).toList(),
        header?.clone(),
      );
}
