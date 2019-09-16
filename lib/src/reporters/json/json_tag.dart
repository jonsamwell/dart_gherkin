class JsonTag {
  final String name;
  final int line;

  JsonTag(this.name, this.line);

  Map<String, dynamic> toJson() {
    return {
      'line': line,
      'name': name,
    };
  }
}
