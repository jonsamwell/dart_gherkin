class JsonEmbedding {
  String? mimeType;
  String? data;

  Map<String, String?> toJson() {
    return {
      'mime_type': mimeType,
      'data': data,
    };
  }
}
