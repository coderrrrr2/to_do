import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:to_do_app/models/to_do.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

bool isSearching = false;

Future<Database> getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final database = await sql.openDatabase(
    path.join(dbPath, 'TodoDb'),
    onCreate: (dbInstance, version) async {
      await dbInstance.execute(
        "CREATE TABLE user_todo(id TEXT PRIMARY KEY, task TEXT, time TEXT, date DATETIME)",
      );

      await dbInstance.execute(
        "CREATE TABLE user_settings(isNotifications BOOL, isLightMode BOOL, chosenLanguage TEXT, timeFormat TEXT)",
      );
    },
  );
  return database;
}

final dummyData = [
  ToDo(
    taskName: 'Task 1',
    date: DateTime.now(),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Monday',
  ),
  ToDo(
    taskName: 'Task 2',
    date: DateTime.now().add(Duration(days: 1)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Friday',
  ),
  ToDo(
    taskName: 'Task 3',
    date: DateTime.now().add(Duration(days: 2)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Wednesday',
  ),
  ToDo(
    taskName: 'Task 4',
    date: DateTime.now().add(Duration(days: 3)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Thursday',
  ),
  ToDo(
    taskName: 'Task 5',
    date: DateTime.now().add(Duration(days: 4)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Sunday',
  ),
  ToDo(
    taskName: 'Task 6',
    date: DateTime.now().add(Duration(days: 5)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Tuesday',
  ),
  ToDo(
    taskName: 'Task 7',
    date: DateTime.now().add(Duration(days: 6)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Saturday',
  ),
  ToDo(
    taskName: 'Task 8',
    date: DateTime.now().add(Duration(days: 7)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Monday',
  ),
  ToDo(
    taskName: 'Task 9',
    date: DateTime.now().add(Duration(days: 8)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Friday',
  ),
  ToDo(
    taskName: 'Task 10',
    date: DateTime.now().add(Duration(days: 9)),
    time: TimeOfDay.now(),
    repeatTaskDays: 'Wednesday',
  ),
];

class ListManipulator extends StateNotifier<List<ToDo>> {
  ListManipulator() : super(dummyData);

  void add(ToDo todo) {
    state = [...state, todo];
  }

  void remove(ToDo todo) {
    state = state.where((element) => element != todo).toList();
  }
}

final listManipulatorProvider =
    StateNotifierProvider<ListManipulator, List<ToDo>>((ref) {
  return ListManipulator();
});
