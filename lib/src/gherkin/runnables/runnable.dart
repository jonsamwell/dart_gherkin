import 'debug_information.dart';

abstract class Runnable {
  RunnableDebugInformation debug;
  String get name;

  Runnable(this.debug);
}
