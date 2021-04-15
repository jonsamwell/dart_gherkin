class JsonRow {
  List<String?> cells = <String?>[];

  JsonRow(this.cells);

  Map<String, dynamic> toJson() {
    return {
      'cells': cells,
    };
  }
}
