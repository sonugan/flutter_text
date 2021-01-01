import 'dart:async';
import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
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
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  JumpingDotsProgressIndicator(
                    fontSize: 20.0,
                  )
                ],
              )
            );
          }else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
          }
        task = snapshot.data;
        final TaskArguments args = ModalRoute.of(context).settings.arguments;
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
                    child: ListView.builder(
                      itemCount: snapshot.data.getOrderedSteps().length,
                      itemBuilder: (context, index) {
                        TaskStep step = task != null ? task.getOrderedSteps()[index] : snapshot.data.getOrderedSteps()[index];
                        return Column(children: <Widget>[
                           Card(
                            borderOnForeground: true,
                            elevation: 1,
                            margin: step.started ? EdgeInsets.all(4.0) : EdgeInsets.fromLTRB(0,0,0,0),
                            color: Colors.white,
                            child: ListTile(
                              leading: Text(
                                step.order.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            title: Text(step.description))
                          )],
                        );
                      }
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
                            // if (timer.isActive) {
                            //   timer.cancel();
                            // }
                            
                            _start(true);
                            // task.start();
                          } else {
                            //timer.cancel();
                            _stop();
                            timer.cancel();
                          }
                          // _checkIfFinish();
                        });
                        //Start task
                      },),
                ],
              ),
            ));
      }
    );
  }

  Isolate _isolate;
  bool _running = false;
  String notification = "";
  ReceivePort _receivePort;
  Timer timer;
  void _start(bool startTask) async {
    _running = true;
    const oneSec = const Duration(seconds:10);
    timer = new Timer.periodic(oneSec, (Timer t) => {
      _checkTasksStatus()
    });
    if (startTask) {
      task.start();
    }
  }

  void _checkTasksStatus() {
    _checkIfFinish();
    // var t = task;
    // setState(() {
    //   task = t;
    // });
  }

  void _stop() {
    if (_isolate != null) {
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;        
      }
  }

  var started = false;
  var isChecking = false;
  _checkIfFinish() {
      if(started && !isChecking) {
        isChecking = true;
        timer.cancel();
        var values = task.needToCheck();
        if(values.length > 0) {
          values.forEach((s) {
           TalkService.getInstance().speach('¿Terminaste el paso ' + s.order.toString() + '?');
           TalkService.getInstance().listen(() => _stepFinalized(s), () => _stepNotFinalized(s));
          });
        }
        _start(true);
        isChecking = false;
      }
  }

  _stepFinalized(TaskStep step) {
    print(step);
    step.finish();
    print('La tarea ha finalizado!!!!');
  }

  _stepNotFinalized(TaskStep step) {
    print(step);
    print('La tarea NO ha finalizado!!!!');
  }
}
