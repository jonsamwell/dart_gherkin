import 'package:matcher/matcher.dart';

class PathPartMatcher extends Matcher {
  late final Iterable<String> relativePaths;
  final description = StringDescription();

  PathPartMatcher(this.relativePaths);

  @override
  Description describe(Description description) {
    return description..add(description.toString());
  }

  @override
  bool matches(dynamic absolutePaths, Map matchState) {
    var match = true;

    for (final absPath in absolutePaths as Iterable<String>) {
      var internalMatch = false;

      for (final relativePath in relativePaths) {
        if (absPath.contains(relativePath)) {
          internalMatch = true;
          break;
        }
      }

      match = match && internalMatch;
    }

    return match;
  }
}
