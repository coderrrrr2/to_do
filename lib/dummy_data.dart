import 'package:flutter/material.dart';
import 'package:to_do_app/models/to_do.dart';

final dummyData = [
  ToDo(
    taskName: 's',
    date: DateTime.now(),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Monday',
  ),
  ToDo(
    taskName: 's',
    date: DateTime.now().add(const Duration(days: 1)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Friday',
  ),
  ToDo(
    taskName: 's',
    date: DateTime.now().add(const Duration(days: 2)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Wednesday',
  ),
  ToDo(
    taskName: 'Task 4',
    date: DateTime.now().add(const Duration(days: 3)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Thursday',
  ),
  ToDo(
    taskName: 'Task 5',
    date: DateTime.now().add(const Duration(days: 4)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Sunday',
  ),
  ToDo(
    taskName: 'Task 6',
    date: DateTime.now().add(const Duration(days: 5)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Tuesday',
  ),
];
