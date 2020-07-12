import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:speach/model/element.dart';
import 'package:speach/model/step.dart';
import 'package:yaml/yaml.dart';

import 'package:speach/model/task.dart';

Future<Task> loadTask(BuildContext context) {
  return loadAsset(context).then((str) {
    var doc = loadYaml(str);
    return new Task(
      name: doc['name'], 
      description: doc['description'], 
      steps: List<TaskStep>.from(doc['steps'].map((s) 
        => new TaskStep(
          order: s['id'],
          description: s['description'],
          dependsOn: new List<TaskStep>(),
          requirements: new List<TaskElement>()
          ))));
  });
}
Future<String> loadAsset(BuildContext context) async {
  return await DefaultAssetBundle.of(context).loadString('assets/tasks/task1.yml');
}