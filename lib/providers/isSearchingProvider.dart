// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchingProvider extends StateNotifier<bool> {
  SearchingProvider() : super(false);

  void setSearching(bool value) {
    state = value;
  }
}

final searchingProvider = StateNotifierProvider<SearchingProvider, bool>((ref) {
  return SearchingProvider();
});
