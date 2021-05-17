class ScenarioContext {
  late final Map<String, dynamic> _scenarioContext = {};

  void setContext(String key, dynamic value) {
    _scenarioContext[key] = value;
  }

  String? getContext(String key) {
    return _scenarioContext[key];
  }

  void dispose() => _scenarioContext.clear();
}
