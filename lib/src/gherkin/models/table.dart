import '../models/table_row.dart';

class Table {
  final Iterable<TableRow> rows;
  final TableRow header;

  Table(this.rows, this.header);

  void setStepParameter(String parameterName, String value) {
    rows.forEach((row) {
      row.setStepParameter(parameterName, value);
    });
  }

  Table clone() => Table(rows.map((r) => r.clone()).toList(), header.clone());
}
