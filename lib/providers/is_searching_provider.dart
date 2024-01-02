import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsSearchingProvider extends StateNotifier<bool> {
  IsSearchingProvider() : super(false);

  void setSearching(bool value) {
    state = value;
  }
}

final isSearchingProvider =
    StateNotifierProvider<IsSearchingProvider, bool>((ref) {
  return IsSearchingProvider();
});
