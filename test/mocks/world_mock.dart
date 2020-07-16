import 'package:gherkin/gherkin.dart';

class WorldMock extends World {
  bool disposeFnInvoked = false;

  @override
  void dispose() => disposeFnInvoked = true;
}

class WorldMockThatThrowsWhenDisposed extends World {
  bool disposeFnInvoked = false;

  @override
  void dispose() => throw Exception('Error occurred in dispose');
}
