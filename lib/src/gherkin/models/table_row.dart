class TableRow {
  final bool isHeaderRow;
  final int rowIndex;
  Iterable<String?> _columns;
  Iterable<String?> get columns => _columns;

  TableRow(
    this._columns,
    this.rowIndex, {
    required this.isHeaderRow,
  });

  void setStepParameter(String parameterName, String value) {
    _columns = _columns.map((c) => c?.replaceAll('<$parameterName>', value));
  }

  TableRow clone() => TableRow(
        List.of(_columns),
        rowIndex,
        isHeaderRow: isHeaderRow,
      );
}
