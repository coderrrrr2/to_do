import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/backend/sqflite_service.dart';

class ListManipulator extends StateNotifier<List<ToDo>> {
  ListManipulator() : super([]);

  void set() async {
    final todos = await SqfLiteService().loadPlaces();
    state = todos;
  }

  void add(ToDo todo) async {
    state = [...state, todo];
    SqfLiteService().insertIntoDatabase(todo);
  }

  void remove(ToDo todo) async {
    state = state.where((element) => element != todo).toList();
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
