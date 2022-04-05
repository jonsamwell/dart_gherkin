/// Interface provides [serialize] objects to type [T]
abstract class SerializableReporter<T> {
  T serialize();
}

abstract class JsonSerializableReporter extends SerializableReporter<String> {}

typedef WriteReportCallback = Future<void> Function(String report, String path);
