part of '../messages.dart';

class TestMessage extends ActionMessage {
  final List<Tag> tags;

  TestMessage({
    required Target target,
    required String name,
    required RunnableDebugInformation context,
    this.tags = const [],
  }) : super(
          target: target,
          name: name,
          context: context,
        );

  TestMessage copyWith({
    Target? target,
    String? name,
    RunnableDebugInformation? context,
    List<Tag>? tags,
  }) {
    return TestMessage(
      target: target ?? this.target,
      name: name ?? this.name,
      context: context ?? this.context,
      tags: tags ?? this.tags,
    );
  }
}
