import '../messages.dart';

class JsonTag {
  final String name;
  final int line;

  const JsonTag(this.name, this.line);

  JsonTag.fromMessageTag(Tag tag)
      : name = tag.name,
        line = tag.nonZeroAdjustedLineNumber;

  Map<String, dynamic> toJson() {
    return {
      'line': line,
      'name': name,
    };
  }

  JsonTag copyWith({
    String? name,
    int? line,
  }) {
    return JsonTag(
      name ?? this.name,
      line ?? this.line,
    );
  }
}
