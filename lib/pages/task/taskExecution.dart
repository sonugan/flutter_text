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

  _builder(BuildContext context) {
    return new FutureBuilder<Task>(
      future: loadTask(context),
      builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
         if( snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: Text('Please wait its loading...'));
          }else if (snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
          }

        final TaskArguments args = ModalRoute.of(context).settings.arguments;
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
                        "Iniciar",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        talkService.speach('Iniciando tarea');
                        //Start task
                      },),
                ],
              ),
            ));
      }
    );
  }
}

var talkService = new TalkService();