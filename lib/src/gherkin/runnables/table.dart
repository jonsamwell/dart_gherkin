import '../models/table.dart';
import '../models/table_row.dart';
import './comment_line.dart';
import './debug_information.dart';
import './runnable.dart';
import './runnable_block.dart';

class TableRunnable extends RunnableBlock {
  final List<String> rows = <String>[];

  @override
  String get name => 'Table';

  TableRunnable(RunnableDebugInformation debug) : super(debug);

  @override
  void addChild(Runnable? child) {
    switch (child.runtimeType) {
      case TableRunnable:
        rows.addAll((child as TableRunnable).rows);
        break;
      case CommentLineRunnable:
        break;
      default:
        throw Exception(
            "Unknown runnable child given to Table '${child.runtimeType}'");
    }
  }

  Table toTable() {
    TableRow? header;
    final tableRows = <TableRow>[];
    if (rows.length > 1) {
      header = _toRow(rows.first, 0, true);
    }

    for (var i = (header == null ? 0 : 1); i < rows.length; i += 1) {
      tableRows.add(_toRow(rows.elementAt(i), i));
    }

    return Table(tableRows, header);
  }

  TableRow _toRow(String raw, int rowIndex, [isHeaderRow = false]) {
    final columns = raw
        .trim()
        .split(RegExp(r'(?<!\\)\|'))
        .map((c) => c.trim().replaceAll(r'\|', '|'))
        .skip(1)
        .toList();

    return TableRow(
      columns
          .take(columns.length - 1)
          .map((v) => v.isEmpty ? null : v)
          .toList(),
      rowIndex,
      isHeaderRow,
    );
  }
}
