import 'json_embedding.dart';
import 'json_row.dart';
import '../messages.dart';
import '../../gherkin/steps/step_run_result.dart';

class JsonStep {
  late final String name;
  late final int line;
  List<JsonRow>? rows;
  List<JsonEmbedding>? embeddings;
  String? error;
  String? docString;
  String? file;
  String? keyword;
  int duration = 0;
  String status = 'failed';

  static JsonStep from(StepStartedMessage message) {
    final step = JsonStep();

    final index = message.name.indexOf(' ');
    final keyword = message.name.substring(0, index + 1);
    final name = message.name.substring(index + 1, message.name.length);

    step.keyword = keyword;
    step.name = name;
    step.line = message.context.nonZeroAdjustedLineNumber;
    step.file = message.context.filePath;
    step.docString = message.multilineString;

    if (message.table?.rows != null && message.table!.rows.isNotEmpty) {
      step.rows = message.table!.rows
          .map(
            (r) => JsonRow(
              r.columns.toList(
                growable: false,
              ),
            ),
          )
          .toList();

      step.rows!.insert(
        0,
        JsonRow(
          message.table!.header!.columns.toList(
            growable: false,
          ),
        ),
      );
    }

    return step;
  }

  void onFinish(StepFinishedMessage message) {
    duration = message.result.elapsedMilliseconds * 1000000; // nano seconds.

    switch (message.result.result) {
      case StepExecutionResult.pass:
        status = 'passed';
        break;
      case StepExecutionResult.skipped:
        status = 'skipped';
        break;
      default:
        break;
    }

    if (message.attachments.isNotEmpty) {
      embeddings = message.attachments
          .map((attachment) => JsonEmbedding()
            ..data = attachment.data
            ..mimeType = attachment.mimeType)
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
      (result['result'] as dynamic)['error_message'] = error;
    }

    if (rows != null && rows!.isNotEmpty) {
      result['rows'] = rows!.toList();
    }

    return result;
  }
}
