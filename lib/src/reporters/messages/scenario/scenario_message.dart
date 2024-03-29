part of '../messages.dart';

/// {@template messages.scenariomessage}
/// A message related to a scenario or scenarioOutline
/// {@endtemplate}
class ScenarioMessage extends ActionMessage {
  /// Has the scenario been executed successfully
  final bool hasPassed;

  /// Gherkin format tags
  final List<Tag> tags;

  final String? description;

  /// {@macro messages.scenariomessage}
  ScenarioMessage({
    required String name,
    required RunnableDebugInformation context,
    this.description,
    this.hasPassed = false,
    this.tags = const [],
    Target target = Target.scenario,
  }) : super(
          target: target,
          name: name,
          context: context,
        );

  ScenarioMessage copyWith({
    String? name,
    String? description,
    RunnableDebugInformation? context,
    bool? hasPassed,
    List<Tag>? tags,
    Target? target,
  }) {
    return ScenarioMessage(
      target: target ?? this.target,
      name: name ?? this.name,
      description: description ?? this.description,
      context: context ?? this.context,
      hasPassed: hasPassed ?? this.hasPassed,
      tags: tags ?? this.tags,
    );
  }
}
