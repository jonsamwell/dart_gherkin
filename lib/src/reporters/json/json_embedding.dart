class JsonEmbedding {
  String? mimeType;
  String? data;

  Map<String, dynamic> toJson() {
    return {
      'mime_type': mimeType,
      'data': data,
    };
  }
}
