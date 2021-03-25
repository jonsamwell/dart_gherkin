import '../exceptions/syntax_error.dart';
import '../models/table.dart';
import './debug_information.dart';
import './multi_line_string.dart';
import './runnable.dart';
import './runnable_block.dart';
import './table.dart';

class StepRunnable extends RunnableBlock {
  String _name;
  String? description;
  List<String> multilineStrings = <String>[];
  Table? table;

  StepRunnable(this._name, RunnableDebugInformation debug) : super(debug);

  @override
  String get name => _name;

  @override
  void addChild(Runnable? child) {
    switch (child.runtimeType) {
      case MultilineStringRunnable:
        multilineStrings
            .add((child as MultilineStringRunnable).lines.join('\n'));
        break;
      case TableRunnable:
        if (table != null) {
          throw GherkinSyntaxException(
              "Only a single table can be added to the step '$name'");
        }

        table = (child as TableRunnable).toTable();
        break;
      default:
        throw Exception(
            "Unknown runnable child given to Step '${child.runtimeType}'");
    }
  }

  void setStepParameter(String? parameterName, String value) {
    _name = _name.replaceAll('<$parameterName>', value);
    table?.setStepParameter(parameterName, value);
    updateDebugInformation(debug.copyWith(debug.lineNumber,
        debug.lineText!.replaceAll('<$parameterName>', value)));
  }

  StepRunnable clone() {
    final cloned = StepRunnable(_name, debug);
    cloned.multilineStrings = multilineStrings.map((s) => s).toList();
    cloned.table = table?.clone();

    return cloned;
  }
}
