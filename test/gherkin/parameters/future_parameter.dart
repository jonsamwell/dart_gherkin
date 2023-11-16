import 'package:gherkin/src/gherkin/parameters/custom_parameter.dart';
import 'package:test/test.dart';

void main() {
  group("StringParameterFuture", () {
    test('{string_future} parsed correctly using an asynchronous callback',
        () async {
      final parameter = StringParameterFuture();
      expect(await parameter.transformer('Jon Samwell'), equals('Jon Samwell'));
    });
  });
}

class StringParameterFuture extends CustomParameter<String> {
  StringParameterFuture()
      : super("string_future", RegExp("['\"](.*)['\"]", dotAll: true),
            (String input) async {
          return Future.delayed(const Duration(milliseconds: 10), () => input);
        });
}
