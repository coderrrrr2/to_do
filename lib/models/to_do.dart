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
    DateTime currentDate = DateTime.now();
    if (currentDate.year == date.year &&
        currentDate.month == date.month &&
        currentDate.day <= date.day &&
        date.day <= currentDate.day + 6) {
      return "Due This Week";
    } else if (currentDate.year == date.year &&
        currentDate.month == date.month &&
        date.day > currentDate.day + 6 &&
        date.day <= currentDate.day + 13) {
      return "Due Next Week";
    } else if (currentDate.year == date.year &&
        currentDate.month == date.month &&
        date.day > currentDate.day + 13) {
      return "Due Later This Month";
    } else if (currentDate.month == 12 && date.month == 1) {
      return "Due Next Month";
    } else if (currentDate.month + 1 == date.month) {
      return "Due Next Month";
    }
    return "Due Later";
  }
}
