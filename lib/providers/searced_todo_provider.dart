import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';

class SearchedToDoProvider extends StateNotifier<List<ToDo>> {
  SearchedToDoProvider() : super([]);

  void set(List<ToDo> todo) {
    state = todo;
  }

  void remove(ToDo todo) {
    state = state.where((element) => element != todo).toList();
  }
}

final searchedToDoProvider =
    StateNotifierProvider<SearchedToDoProvider, List<ToDo>>((ref) {
  return SearchedToDoProvider();
});
