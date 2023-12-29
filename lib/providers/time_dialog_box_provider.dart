import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeValue extends StateNotifier<String> {
  TimeValue() : super('12-hour');

  void setTimeValue(String value) {
    state = value;
  }
}

final timeFormatProvider = StateNotifierProvider<TimeValue, String>((ref) {
  return TimeValue();
});
