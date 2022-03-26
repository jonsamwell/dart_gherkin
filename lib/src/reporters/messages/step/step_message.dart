part of '../messages.dart';

/// {@template messages.stepmessage}
/// A message related to a step
/// {@endtemplate}
class StepMessage extends ActionMessage {
  /// Gherkin format table (optional)
  final GherkinTable? table;

  /// Gherkin format multiline string (optional)
  final String? multilineString;

  /// Gherkin format tags
  final List<Tag> tags;

  /// Step result during program execution
  final StepResult? result;
  final List<Attachment>? attachments;

  /// {@macro messages.stepmessage}
  StepMessage({
    required String name,
    required RunnableDebugInformation context,
    this.tags = const [],
    this.table,
    this.multilineString,
    this.result,
    this.attachments,
  }) : super(
          target: Target.step,
          name: name,
          context: context,
        );

  StepMessage copyWith({
    String? name,
    RunnableDebugInformation? context,
    GherkinTable? table,
    String? multilineString,
    List<Tag>? tags,
    StepResult? result,
    List<Attachment>? attachments,
  }) {
    return StepMessage(
      name: name ?? this.name,
      context: context ?? this.context,
      table: table ?? this.table,
      multilineString: multilineString ?? this.multilineString,
      tags: tags ?? this.tags,
      result: result ?? this.result,
      attachments: attachments ?? this.attachments,
    );
  }
}
