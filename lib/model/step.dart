import 'dart:async';

import 'package:speach/model/element.dart';

class TaskStep {
  TaskStep({int order,
       String description,
       List<TaskStep> dependsOn,
       int time,
       List<TaskElement> requirements}) {
    this.order = order;
    this.description = description;
    _dependsOn = dependsOn;
    this.time = time;
    _requirements = requirements;
  }

  run() {
    _startedTime = new DateTime.now();
    _started = true;
    _checktime(time);
  }

  _checktime(int seconds) {
    timer = Timer.periodic(new Duration(seconds: time), (Timer t) {
      tiempoExcedido = new DateTime.now().difference(_startedTime).inSeconds >= seconds;
      if(tiempoExcedido) {
        timer.cancel();
        _startedTime = new DateTime.now();
        _checktime(seconds);
      }
    });
  }

  var tiempoExcedido = false;

  needToCheck() {
    var tiempoExcedido = this.tiempoExcedido;
    if ( this.tiempoExcedido) {
      this.tiempoExcedido = false;
    }
    return tiempoExcedido;
  }

  Timer timer;

  bool canBeTaked() {
    return !_dependsOn.any((r) => !r._finish);
  }

  int order;
  String description;
  List<TaskStep> _dependsOn;
  int time;
  List<TaskElement> _requirements;
  bool _finish;
  bool _started = false;
  DateTime _startedTime;
}