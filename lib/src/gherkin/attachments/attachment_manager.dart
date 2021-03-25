import 'attachment.dart';

class AttachmentManager {
  final List<Attachment> _attachments = [];

  void attach(String data, String mimeType, [String? context]) {
    _attachments.add(Attachment(data, mimeType, context));
  }

  Iterable<Attachment> getAttachmentsForContext([String? context]) {
    return context == null || context.isNotEmpty
        ? _attachments.where((attachment) => attachment.context == context)
        : _attachments.where((attachment) => attachment.context!.isEmpty);
  }

  void dispose() {
    _attachments.clear();
  }
}
