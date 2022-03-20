import 'package:gherkin/src/gherkin/steps/step_run_result.dart';
import 'package:gherkin/src/reporters/json/json_embedding.dart';
import 'package:gherkin/src/reporters/json/json_row.dart';
import 'package:gherkin/src/reporters/messages.dart';

class JsonStep {
  final String name;
  final int line;
  final List<JsonRow>? rows;
  final String? docString;
  final String? file;
  final String? keyword;

  List<JsonEmbedding>? embeddings;

  /// Error and stacktrace in string
  String? error;

  /// Duration in nano-seconds
  int duration;

  /// [StepExecutionResult] to string named
  String status;

  JsonStep({
    required this.name,
    required this.line,
    this.rows,
    this.embeddings,
    this.error,
    this.docString,
    this.file,
    this.keyword,
    this.duration = 0,
    this.status = 'failed',
  });

  static JsonStep get empty => JsonStep(
        name: 'Unnamed',
        line: 0,
      );

  static JsonStep from(StepStartedMessage message) {
    final index = message.name.indexOf(' ');
    final keyword = message.name.substring(0, index + 1);
    final name = message.name.substring(index + 1, message.name.length);
    var step = JsonStep(
      keyword: keyword,
      name: name,
      line: message.context.nonZeroAdjustedLineNumber,
      file: message.context.filePath,
      docString: message.multilineString,
    );

    if (message.table?.rows != null && message.table!.rows.isNotEmpty) {
      final tableRows = message.table!.rows
          .map(
            (r) => JsonRow(
              r.columns.toList(
                growable: false,
              ),
            ),
          )
          .toList();

      final header = JsonRow(
        message.table!.header!.columns.toList(
          growable: false,
        ),
      );
      step = step.copyWith(
        rows: [
          header,
          ...tableRows,
        ],
      );
    }

    return step;
  }

  String? _statusMapper(StepExecutionResult result) {
    switch (result) {
      case StepExecutionResult.passed:
      case StepExecutionResult.skipped:
        return result.name;
      default:
        return null;
    }
  }

  void onFinish(StepFinishedMessage message) {
    duration = message.result.elapsedMilliseconds * 1000000;
    final newStatus = _statusMapper(message.result.result);
    if (newStatus != null) {
      status = newStatus;
    }

    if (message.attachments.isNotEmpty) {
      embeddings = message.attachments
          .map(
            (attachment) => JsonEmbedding()
              ..data = attachment.data
              ..mimeType = attachment.mimeType,
          )
          .toList();
    }

    _trackError(message.result.resultReason);
  }

  void onException(
    Object exception,
    StackTrace stackTrace,
  ) {
    _trackError(
      exception.toString(),
      stackTrace.toString(),
    );
  }

  void _trackError(
    String? error, [
    String? stacktrace,
  ]) {
    if (error != null && error.isNotEmpty) {
      this.error =
          '$error${stacktrace != null ? '\n\n$stacktrace' : ''}'.trim();
    }
  }

  Map<String, dynamic> toJson() {
    final result = {
      'keyword': keyword,
      'name': name,
      'line': line,
      'match': {
        'location': '$file:$line',
      },
      'result': {
        'status': status,
        'duration': duration,
      }
    };

    if (docString != null && docString!.isNotEmpty) {
      result['docString'] = {
        'content_type': '',
        'value': docString,
        'line': line + 1,
      };
    }

    if (embeddings != null && embeddings!.isNotEmpty) {
      result['embeddings'] = embeddings!.toList();
    }

    if (error != null && error!.isNotEmpty) {
      final resultMap = result['result']! as Map<String, dynamic>;
      resultMap['error_message'] = error;
    }

    if (rows != null && rows!.isNotEmpty) {
      result['rows'] = rows!.toList();
    }

    return result;
  }

  JsonStep copyWith({
    String? name,
    int? line,
    List<JsonRow>? rows,
    List<JsonEmbedding>? embeddings,
    String? error,
    String? docString,
    String? file,
    String? keyword,
    int? duration,
    String? status,
  }) {
    return JsonStep(
      name: name ?? this.name,
      line: line ?? this.line,
      rows: rows ?? this.rows,
      embeddings: embeddings ?? this.embeddings,
      error: error ?? this.error,
      docString: docString ?? this.docString,
      file: file ?? this.file,
      keyword: keyword ?? this.keyword,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }
}
