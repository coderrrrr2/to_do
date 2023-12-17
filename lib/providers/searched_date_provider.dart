import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';

class SearchedDateProvider extends StateNotifier<List<ToDo>> {
  SearchedDateProvider() : super([]);

  void set(List<ToDo> todo) {
    state = todo;
  }

  void remove(ToDo todo) {
    state = state.where((element) => element != todo).toList();
  }

  void insert(ToDo todo, int index) {
    state.insert(index, todo);
  }
}

final searchedDateProvider =
    StateNotifierProvider<SearchedDateProvider, List<ToDo>>((ref) {
  return SearchedDateProvider();
});
