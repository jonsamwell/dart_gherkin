import './debug_information.dart';

abstract class Runnable {
  RunnableDebugInformation _debug;
  RunnableDebugInformation get debug => _debug;
  String? get name;

  Runnable(this._debug);

  void updateDebugInformation(RunnableDebugInformation debugInformation) {
    _debug = debugInformation;
  }
}
