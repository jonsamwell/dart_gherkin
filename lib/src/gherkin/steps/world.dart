import 'package:gherkin/src/gherkin/attachments/attachment_manager.dart';

class World {
  late AttachmentManager _attachmentManager;

  void setAttachmentManager(AttachmentManager attachmentManager) {
    _attachmentManager = attachmentManager;
  }

  /// Attach data to the given [context] which can be a step name
  /// or if blank it will be attached to the scenario
  /// [mimeType] one of 'text/plain', 'text/html', 'application/json', 'image/png'
  void attach(String data, String mimeType, [String? context]) {
    _attachmentManager.attach(data, mimeType, context);
  }

  void dispose() {
    _attachmentManager.dispose();
  }
}
