class JsonEmbedding {
  late final String mimeType;
  late final String data;

  Map<String, dynamic> toJson() {
    return {
      'mime_type': mimeType,
      'data': data,
    };
  }
}
