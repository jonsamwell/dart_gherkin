import './debug_information.dart';
import './runnable.dart';

abstract class RunnableBlock extends Runnable {
  RunnableBlock(RunnableDebugInformation debug) : super(debug);

  void addChild(Runnable? child);
}
