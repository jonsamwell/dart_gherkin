import 'debug_information.dart';
import 'scenario.dart';

class BackgroundRunnable extends ScenarioRunnable {
  BackgroundRunnable(String name, RunnableDebugInformation debug)
      : super(name, null, debug);
}
