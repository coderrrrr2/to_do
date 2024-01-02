import 'package:flutter_riverpod/flutter_riverpod.dart';

class IsSearchInitiatedProvider extends StateNotifier<bool> {
  IsSearchInitiatedProvider() : super(false);

  void setSearching(bool value) {
    state = value;
  }
}

final isSearchInitiatedProvider =
    StateNotifierProvider<IsSearchInitiatedProvider, bool>((ref) {
  return IsSearchInitiatedProvider();
});
