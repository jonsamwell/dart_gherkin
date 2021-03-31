import 'package:gherkin/gherkin.dart';
import 'package:test/test.dart';

import '../mocks/world_mock.dart';

void main() {
  group('function steps', () {
    test('step with 1 parameter is invoked', () async {
      const parameter1Value = 1;
      int? parameter1GivenValue;

      final stepMethod = when1(
        'pattern',
        (int input1, _) {
          parameter1GivenValue = input1;
          return Future.value(null);
        },
      );

      await stepMethod
          .run(null, null, const Duration(seconds: 10), [parameter1Value]);
      expect(parameter1GivenValue, parameter1Value);
    });

    test('step is invoked with custom world', () async {
      final customWorld = WorldMock();
      World? receivedWorld;

      final stepMethod = given2(
        'pattern',
        (int input1, String input2, StepContext ctx) {
          receivedWorld = ctx.world;
          return Future.value(null);
        },
      );

      await stepMethod
          .run(customWorld, null, const Duration(seconds: 10), [1, '2']);
      expect(receivedWorld, customWorld);
    });
  });
}
