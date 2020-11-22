import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:speach/model/step.dart';

class Task {
  Task({this.id, this.description, this.name, List<TaskStep> steps}) {
    _steps = steps;
  }

  Isolate isolate;  
  List<TaskStep> currentSteps = [];
  final isolates = IsolateHandler();
  start() async {
     // isolates.spawn(entryPoint, 
    // name: 'Paso1',
    // onReceive: (d) {
    //   print(d);
    // },
    // onInitialized: () => isolates.send('asdsf', to: 'path'));
    
    var possibleTasks = _getAllStepsCanTake();
    if(possibleTasks.length > 0){
      var step = possibleTasks[0];
      step.run();
      currentSteps.add(step);
    }
  }

  void entryPoint(Map<String, dynamic> context) {
    final messenger = HandledIsolate.initialize(context);
    messenger.listen((c) {
      messenger.send(c +1 );
    });
    messenger.send(1);
  }

  List<TaskStep> needToCheck() {
    if (currentSteps.length == 0) {
      var a = 0;
    }
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

  String id;
  List<TaskStep> _steps;
  String name;
  String description;
}