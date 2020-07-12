import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speach/model/task.dart';

class TaskListPage extends StatelessWidget {
  final _tasks = <Task>[
    Task(id: 'task1.yml', name: 'Cocinando huevo frito', description: 'Los huevos fritos se fríen solamente de un lado, para que la yema quede líquida y pueda ser untada con pan. Aunque su procedimiento de cocción parezca sencillo, hay muchas personas que los dejan muy crudos o demasiado cocidos, por lo que la yema se endurece y ya no hay vuelta atrás')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tareas'), centerTitle: true,),
      body: Container(
        child: _buildTaskList(context)
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return ListView.builder(
      itemCount: _tasks.length, 
      itemBuilder: (context, position) => GestureDetector(
        child: _buildTaskListItems(context, position),
        onTap: () {
          Navigator.pushNamed(context, '/taskExecution', arguments: TaskArguments(_tasks[position].id));
        },
      ) 
    );
  }

  Widget _buildTaskListItems(BuildContext context, int position) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                child: Text(
                  _tasks[position].name, 
                  style: TextStyle(
                    fontSize: 22.0, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              // Expanded(
              //   child: Text(
              //     _tasks[position].description,
              //     style: TextStyle(
              //       fontSize: 18
              //     ),
              //   ),
              // )
            ],
          )
        ])
    ;
  }
} 


class TaskArguments {
  final String taskName;
  
  TaskArguments(this.taskName);
}