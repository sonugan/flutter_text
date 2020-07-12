import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:speach/model/step.dart';

class Task {
  Task({this.description, this.name, List<TaskStep> steps}) {
    _steps = steps;
  }

  Isolate isolate;  
  List<TaskStep> currentSteps = [];

  start() {
    var possibleTasks = _getAllStepsCanTake();
    if(possibleTasks.length > 0){
      var step = possibleTasks[0];
      step.run();
      currentSteps.add(step);
    }
  }

  List<TaskStep> needToCheck() {
    return currentSteps.where((s) => s.needToCheck()).toList();
  }

  finish() {

  }

  List<TaskStep> _getAllStepsCanTake() {
    return _steps.where((s) => s.canBeTaked()).toList();
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