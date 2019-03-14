import '../models/table_row.dart';

class Table {
  final Iterable<TableRow> rows;
  final TableRow header;

  Table(this.rows, this.header);
}
