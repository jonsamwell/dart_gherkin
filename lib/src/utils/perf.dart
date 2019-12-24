import 'dart:async';

class Perf {
  static Future<T> measure<T>(
    Future<T> Function() action,
    void Function(int elapsedMilliseconds) logFn,
  ) async {
    final timer = Stopwatch();
    timer.start();
    try {
      return await action();
    } finally {
      timer.stop();
      logFn(timer.elapsedMilliseconds);
    }
  }
}
