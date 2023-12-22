import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/backend/sqflite_service.dart';

bool isSearching = false;

class ListManipulator extends StateNotifier<List<ToDo>> {
  ListManipulator() : super([]);

  Future<void> loadPlaces() async {
    final db = await SqfLiteService().initializeDataBase();
    final data = await db.query('user_todos');
    print(data);

    var places = data.map((row) {
      return ToDo(
        taskName: row['taskName'] as String,
        date: row['date'] as DateTime,
        time: _parseTimeOfDay(row['time'] as String),
        repeatTaskDays: row['repeatTaskDays'] as String,
        id: row['id'] as String,
        isChecked: row["isChecked"] == 1,
      );
    }).toList();

    state = places;
  }

  void add(ToDo todo) async {
    state = [...state, todo];
    SqfLiteService().insertIntoDatabase(todo);
  }

  void remove(ToDo todo) async {
    state = state.where((element) => element != todo).toList();
    SqfLiteService().deleteFromDataBase(todo);
  }

  void editToDo(ToDo todo, int index) {
    state.insert(index, todo);
  }

  int getIndex(ToDo todo) {
    return state.indexOf(todo);
  }
}

final toDoProvider = StateNotifierProvider<ListManipulator, List<ToDo>>((ref) {
  return ListManipulator();
});

TimeOfDay _parseTimeOfDay(String timeString) {
  List<String> components = timeString.split(':');
  int hour = int.parse(components[0]);
  int minute = int.parse(components[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
