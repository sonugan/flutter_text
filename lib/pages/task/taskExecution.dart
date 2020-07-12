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
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Text(
                      snapshot.data.description,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Divider(color: Colors.black),
                  Container(
                    child: Text('Pasos', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: snapshot.data.getOrderedSteps().length,
                      itemBuilder: (context, index) {
                        var step = snapshot.data.getOrderedSteps()[index];
                        return ListTile(
                          leading: Text(
                            step.order.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                          title: Text(step.description));
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    )
                  ),
                  FlatButton(
                    child: Text(
                        !started ? "Iniciar" : "Pausar",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        setState(() {
                          started = !started;
                          if(started) {
                            task.start();
                          } else {
                            _checkIfFinish();
                          }
                        });
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