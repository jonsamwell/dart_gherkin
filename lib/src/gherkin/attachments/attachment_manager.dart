import 'package:gherkin/src/gherkin/attachments/attachment.dart';

class AttachmentManager {
  final List<Attachment> _attachments = [];

  void attach(
    String data,
    String mimeType, [
    String? context,
  ]) {
    _attachments.add(Attachment(data, mimeType, context));
  }

  Iterable<Attachment> getAttachmentsForContext([
    String? context,
  ]) {
    return _attachments.where((attachment) => attachment.context == context);
  }

  void dispose() {
    _attachments.clear();
  }
}
