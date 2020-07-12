import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speach/model/step.dart';
import 'package:speach/model/task.dart';
import 'package:speach/pages/task/taskList.dart';
import 'package:speach/services/talkService.dart';
import 'package:speach/services/taskFactory.dart';

class TaskExecution extends StatefulWidget {
  TaskExecution({Key key}) : super(key: key);

  @override
  _TaskExecutionState createState() => _TaskExecutionState();
}

class _TaskExecutionState extends State<TaskExecution> {
  @override
  Widget build(BuildContext context) {
   return _builder(context);
  }

  Task task;

  _builder(BuildContext context) {
    return new FutureBuilder<Task>(
      future: loadTask(context),
      builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
         if( snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: Text('Please wait its loading...'));
          }else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
          }
        _checkIfFinish();
        final TaskArguments args = ModalRoute.of(context).settings.arguments;
            task = snapshot.data;
            return Scaffold(
              appBar: AppBar(title: Text(snapshot.data.name), centerTitle: true,),
              body: Container(
              child: Column(
                children: <Widget>[
                  Text(snapshot.data.description),
                  Text('Pasos'),
                  Expanded(
                    //height: 44.0,
                    child: ListView.builder(
                      itemCount: snapshot.data.getOrderedSteps().length,
                      itemBuilder: (context, index) {
                        var step = snapshot.data.getOrderedSteps()[index];
                        return ListTile(
                          leading: Text(step.order.toString()),
                          title: Text(step.description));
                      }
                    )
                  ),
                  FlatButton(
                    child: Text(
                        !started ? "Iniciar" : "Pausar",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        talkService.speach('Deja fundir la grasa hasta que comience a chisporrotear cuando viertas una gotita de agua.');
                        // setState(() {
                        //   started = !started;
                        //   if(started) {
                        //     task.start();
                        //   } else {
                        //     _checkIfFinish();
                        //   }
                        // });
                        //Start task
                      },),
                ],
              ),
            ));
      }
    );
  }

  var started = false;
  var isChecking = false;
  Timer timer;
  _checkIfFinish() {
    timer = Timer.periodic(new Duration(seconds: 2), (Timer t) {
      if(started && !isChecking) {
        isChecking = true;
        var values = task.needToCheck();
        if(values.length > 0) {
          values.forEach((s) {
            talkService.speach('¿Terminaste el paso ' + s.order.toString() + '?');
          });
        }
        isChecking = false;
      }
    });
  }
}

var talkService = new TalkService();