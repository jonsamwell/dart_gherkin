import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

void main() {
  group('attach', () {
    test('saves attachment', () async {
      final manager = AttachmentManager();
      final data = 'data';
      final mimeType = 'mimeType';

      manager.attach(data, mimeType);

      expect(manager.getAttachmentsForContext().length, equals(1));
      expect(manager.getAttachmentsForContext().first.data, equals(data));
      expect(
          manager.getAttachmentsForContext().first.mimeType, equals(mimeType));
      expect(manager.getAttachmentsForContext('context').length, equals(0));
    });

    test('saves attachment with context', () async {
      final manager = AttachmentManager();
      final data = 'data';
      final mimeType = 'mimeType';
      final context = 'context';

      manager.attach(data, mimeType, context);

      expect(manager.getAttachmentsForContext(context).length, equals(1));
      expect(
          manager.getAttachmentsForContext(context).first.data, equals(data));
      expect(manager.getAttachmentsForContext(context).first.mimeType,
          equals(mimeType));
      expect(manager.getAttachmentsForContext(context).first.context,
          equals(context));
      expect(manager.getAttachmentsForContext().length, equals(0));
    });
  });
}
