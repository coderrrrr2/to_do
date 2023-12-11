// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonPressedProvider extends StateNotifier<bool> {
  ButtonPressedProvider() : super(false);

  void setSearching(bool value) {
    state = value;
  }
}

final buttonPressedProvider =
    StateNotifierProvider<ButtonPressedProvider, bool>((ref) {
  return ButtonPressedProvider();
});
