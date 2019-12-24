import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

void main() {
  group('attach', () {
    test('saves attachment', () async {
      final manager = AttachmentManager();
      final data = 'data';
      final mimeType = 'mimeType';

      manager.attach(data, mimeType);

      expect(manager.getAttachementsForContext().length, equals(1));
      expect(manager.getAttachementsForContext().first.data, equals(data));
      expect(
          manager.getAttachementsForContext().first.mimeType, equals(mimeType));
      expect(manager.getAttachementsForContext('context').length, equals(0));
    });

    test('saves attachment with context', () async {
      final manager = AttachmentManager();
      final data = 'data';
      final mimeType = 'mimeType';
      final context = 'context';

      manager.attach(data, mimeType, context);

      expect(manager.getAttachementsForContext(context).length, equals(1));
      expect(
          manager.getAttachementsForContext(context).first.data, equals(data));
      expect(manager.getAttachementsForContext(context).first.mimeType,
          equals(mimeType));
      expect(manager.getAttachementsForContext(context).first.context,
          equals(context));
      expect(manager.getAttachementsForContext().length, equals(0));
    });
  });
}
