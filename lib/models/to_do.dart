import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class ToDo {
  final String taskName;
  final String id;
  final DateTime date;
  final TimeOfDay time;
  late String taskDayClassification;
  final String repeatTaskDays;

  ToDo({
    required this.taskName,
    required this.date,
    required this.time,
    required this.repeatTaskDays,
    String? id,
  }) : id = id ?? const Uuid().v4() {
    taskDayClassification = _setTaskDayClassification(date);
  }

  String _setTaskDayClassification(DateTime date) {
    if (DateTime.now() == date) {
      log(DateTime.now().toString());
      log(date.toString());
      return 'Today';
    }
    return 'some classification';
  }
}
