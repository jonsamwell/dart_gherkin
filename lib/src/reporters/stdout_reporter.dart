import 'dart:io';
import './message_level.dart';
import './reporter.dart';

class StdoutReporter extends Reporter {
  static const String NEUTRAL_COLOR = '\u001b[33;34m'; // blue
  static const String DEBUG_COLOR = '\u001b[1;30m'; // gray
  static const String FAIL_COLOR = '\u001b[33;31m'; // red
  static const String WARN_COLOR = '\u001b[33;10m'; // yellow
  static const String RESET_COLOR = '\u001b[33;0m';
  static const String PASS_COLOR = '\u001b[33;32m'; // green

  final MessageLevel logLevel;
  final bool? _supportsAnsiEscapes;
  late void Function(String text) _writeln;
  late void Function(String text) _write;

  bool get supportsAnsiEscapes {
    return _supportsAnsiEscapes != null
        ? _supportsAnsiEscapes!
        : stdout.supportsAnsiEscapes;
  }

  StdoutReporter([
    this.logLevel = MessageLevel.verbose,
    this._supportsAnsiEscapes,
  ]) {
    _writeln = (text) => stdout.writeln(text);
    _write = (text) => stdout.write(text);
  }

  void setWriteLineFn(void Function(String text) fn) {
    _writeln = fn;
  }

  void setWriteFn(void Function(String text) fn) {
    _write = fn;
  }

  @override
  Future<void> message(String message, MessageLevel level) async {
    if (level.index >= logLevel.index) {
      printMessageLine(message, getColour(level));
    }
  }

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) async {
    printMessageLine(exception.toString(), getColour(MessageLevel.error));
  }

  String getColour(MessageLevel level) {
    switch (level) {
      case MessageLevel.verbose:
      case MessageLevel.debug:
        return DEBUG_COLOR;
      case MessageLevel.error:
        return FAIL_COLOR;
      case MessageLevel.warning:
        return WARN_COLOR;
      case MessageLevel.info:
      default:
        return NEUTRAL_COLOR;
    }
  }

  void printMessageLine(
    String message, [
    String? colour,
  ]) {
    if (supportsAnsiEscapes) {
      _writeln('${colour ?? RESET_COLOR}$message$RESET_COLOR');
    } else {
      _writeln(message);
    }
  }

  void printMessage(
    String message, [
    String? colour,
  ]) {
    if (supportsAnsiEscapes) {
      _write('${colour ?? RESET_COLOR}$message$RESET_COLOR');
    } else {
      _writeln(message);
    }
  }
}
