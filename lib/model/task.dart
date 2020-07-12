import 'package:speach/model/step.dart';

class Task {
  Task({this.description, this.name, List<TaskStep> steps}) {
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

  List<TaskStep> getOrderedSteps() {
    var orderedSteps = _steps.map((s) => s).toList();
    // orderedSteps.sort((s1, s2) { 
    //   if (s1.order < s2.order) return -1;
    //   if (s1.order > s2.order) return 1;
    //   return 0; 
    // });
    return orderedSteps;
  }

  List<TaskStep> _steps;
  String name;
  String description;
}