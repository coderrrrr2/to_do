import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/services/sqflite/sqflite_service.dart';

class ListManipulator extends StateNotifier<List<ToDo>> {
  ListManipulator() : super([]);
  SqfLiteService sqflite = SqfLiteService();
  void set() async {
    final todos = await sqflite.loadPlaces();
    state = todos;
  }

  void add(ToDo todo) async {
    state = [...state, todo];
    sqflite.insertIntoDatabase(todo);
  }

  void remove(ToDo todo) async {
    state = state.where((element) => element != todo).toList();
    sqflite.deleteFromDataBase(todo);
  }

  void editToDo(
      {required ToDo newtodo, required int index, required ToDo oldtodo}) {
    state = state.where((element) => element != oldtodo).toList();
    state.insert(index, newtodo);
    sqflite.updateDataBaseValue(oldtodo: oldtodo, newtodo: newtodo);
  }

  int getIndex(ToDo todo) {
    return state.indexOf(todo);
  }
}

final toDoProvider = StateNotifierProvider<ListManipulator, List<ToDo>>((ref) {
  return ListManipulator();
});
