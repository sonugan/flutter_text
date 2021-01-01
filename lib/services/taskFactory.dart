import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:speach/model/element.dart';
import 'package:speach/model/step.dart';
import 'package:yaml/yaml.dart';

import 'package:speach/model/task.dart';

Future<Task> loadTask(BuildContext context) {
  return loadAsset(context).then((str) {
    var doc = loadYaml(str);
    var steps = List<TaskStep>.from(doc['steps'].map((s) 
        => new TaskStep(
          order: s['id'],
          description: s['description'],
          dependsOnIds: s['require']?.toList()?.cast<int>(),
          time: s['time'],
          requirements: new List<TaskElement>()
          )));
    
    steps.forEach((s) => 
      s.dependsOn = s.dependsOnIds?.map((sid) => steps.firstWhere((s) => s.order == sid))?.toList()?.cast<TaskStep>()
    );

    currentTask = new Task(
      name: doc['name'], 
      description: doc['description'], 
      steps: steps
    );
    return currentTask;
  });
}
Future<String> loadAsset(BuildContext context) async {
  return await DefaultAssetBundle.of(context).loadString('assets/tasks/task1.yml');
}
Task currentTask;