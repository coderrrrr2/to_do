import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';

class ListManipulator extends StateNotifier<List<ToDo>> {
  ListManipulator() : super([]);
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
