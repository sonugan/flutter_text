import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speach/pages/task/taskList.dart';
import 'package:speach/services/talkService.dart';

class TaskExecution extends StatefulWidget {
  TaskExecution({Key key}) : super(key: key);

  @override
  _TaskExecutionState createState() => _TaskExecutionState();
}

class _TaskExecutionState extends State<TaskExecution> {
  @override
  Widget build(BuildContext context) {
    final a = ModalRoute.of(context);
    final TaskArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(args.taskName), centerTitle: true,),
      body: Container(
       child: Column(
         children: <Widget>[
           IconButton(
             icon: Icon(Icons.star),
              onPressed: () {
                talkService.speach('esta es una prueba de sonido en español. Por favor espere su finalización');
                //Start task
              },)
         ],
       ),
    ));
  }
}

var talkService = new TalkService();