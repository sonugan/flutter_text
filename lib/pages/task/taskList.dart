import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  final _tasks = <String>[
    "Task 1", "Task 2"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tareas'), centerTitle: true,),
      body: Center(
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
          Navigator.pushNamed(context, '/taskExecution', arguments: TaskArguments(_tasks[position]));
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
                  _tasks[position], 
                  style: TextStyle(
                    fontSize: 22.0, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 6, 12, 12),
                child: Text(
                  'Desc',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
              )
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