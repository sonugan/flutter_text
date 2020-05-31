import 'package:speach/model/element.dart';

class TaskStep {
  TaskStep({int order,
       String description,
       List<TaskStep> dependsOn,
       List<TaskElement> requirements}) {
    _order = order;
    _description = description;
    _dependsOn = dependsOn;
    _requirements = requirements;
  }

  run() {
    
  }

  bool canBeTaked() {
    return !_dependsOn.any((r) => !r._finish);
  }

  int _order;
  String _description;
  List<TaskStep> _dependsOn;
  List<TaskElement> _requirements;
  bool _finish;
}