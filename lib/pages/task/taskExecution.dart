import 'dart:async';
import 'dart:io';
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

  static Task task;

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
                            // shape: ContinuousRectangleBorder(
                            //   borderRadius: BorderRadius.zero,
                            // ),
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
                            _start();
                            task.start();
                          } else {
                            //timer.cancel();
                            _stop();
                          }
                          _checkIfFinish();
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
  static int _counter = 0;
  String notification = "";
  ReceivePort _receivePort;
 
  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    // SendPort sendPort = await _receivePort.first;
    _receivePort.sendPort.send(task);
    _receivePort.listen(_handleMessage, onDone:() {
        print("done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 1), (Timer t) async {
      try {
        var port = new ReceivePort();
        //sendPort.send(port.sendPort);
        await for (var data in port) {
          if (data != null) {
            var steps = data.needToCheck();
            _counter++;
            sendPort.send(steps);
          }
        }
      } catch(e){
        print(e);
      }
    });
  }

  void _handleMessage(dynamic steps) {
    if(steps != null && steps.length > 0) {
      print('a');
    }
  }

  void _stop() {
    if (_isolate != null) {
      // setState(() {
      //     _running = false; 
      //     notification = '';   
      // });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;        
      }
  }

  var started = false;
  var isChecking = false;
  //Timer timer;
  _checkIfFinish() {
    // timer = Timer.periodic(new Duration(seconds: 2), (Timer t) {
    //   if(started && !isChecking) {
    //     isChecking = true;
    //     var values = task.needToCheck();
    //     if(values.length > 0) {
    //       values.forEach((s) {
    //        // talkService.speach('¿Terminaste el paso ' + s.order.toString() + '?');
    //       });
    //     }
    //     isChecking = false;
    //   }
    // });
  }
}

var talkService = new TalkService();