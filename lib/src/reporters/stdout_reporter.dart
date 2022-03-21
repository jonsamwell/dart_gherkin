import 'dart:io';
import 'message_level.dart';
import 'reporter.dart';

class StdoutReporter implements InfoReporter {
  static const String kNeutralColor = '\u001b[33;34m'; // blue
  static const String kDebugColor = '\u001b[1;30m'; // gray
  static const String kFailColor = '\u001b[33;31m'; // red
  static const String kWarnColor = '\u001b[33;10m'; // yellow
  static const String kResetColor = '\u001b[33;0m';
  static const String kPassColor = '\u001b[33;32m'; // green

  final MessageLevel logLevel;
  final bool? _supportsAnsiEscapes;
  late void Function(String text) _writeln;
  late void Function(String text) _write;

  bool get supportsAnsiEscapes {
    try {
      return _supportsAnsiEscapes != null
          ? _supportsAnsiEscapes!
          : stdout.supportsAnsiEscapes;
    } catch (_, __) {
      // stdout.supportsAnsiEscapes throws in the web environment
      // see https://github.com/dart-lang/sdk/blob/main/sdk/lib/_internal/js_dev_runtime/patch/io_patch.dart#L622
      return false;
    }
  }

  StdoutReporter([
    this.logLevel = MessageLevel.verbose,
    // ignore: avoid_positional_boolean_parameters
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
        return kDebugColor;
      case MessageLevel.error:
        return kFailColor;
      case MessageLevel.warning:
        return kWarnColor;
      case MessageLevel.info:
      default:
        return kNeutralColor;
    }
  }

  void printMessageLine(
    String message, [
    String? colour,
  ]) {
    if (supportsAnsiEscapes) {
      _writeln('${colour ?? kResetColor}$message$kResetColor');
    } else {
      _writeln(message);
    }
  }

  void printMessage(
    String message, [
    String? colour,
  ]) {
    if (supportsAnsiEscapes) {
      _write('${colour ?? kResetColor}$message$kResetColor');
    } else {
      _writeln(message);
    }
  }
}
