import 'package:speach/model/step.dart';

class Task {
  Task({description, name, List<TaskStep> steps}) {
    _name = name;
    _description = description;
    _steps = steps;
  }

  start() {
    _getAllStepsCanTake();
  }

  finish() {

  }

  List<TaskStep> _getAllStepsCanTake() {
    return _steps.where((s) => s.canBeTaked());
  }

  List<TaskStep> _steps;
  String _name;
  String _description;
}