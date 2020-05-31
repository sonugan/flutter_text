import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speach/pages/task/taskExecution.dart';
import 'package:speach/pages/task/taskList.dart';
import 'package:speach/services/talkService.dart';
import 'package:speach/services/taskFactory.dart';

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    loadTask(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => TaskListPage(),
        '/taskExecution': (context) => TaskExecution()
      }
    );
  }
}


