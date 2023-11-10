// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeValue extends StateNotifier<String> {
  TimeValue() : super('24-hour');

  void setTimeValue(String value) {
    state = value;
  }
}

final timeValueProvider = StateNotifierProvider<TimeValue, String>((ref) {
  return TimeValue();
});

class FirstDayOfTheWeek extends StateNotifier<String> {
  FirstDayOfTheWeek() : super('Sunday');

  void setFirstDayOfTheWeek(String value) {
    state = value;
  }
}

final firstDayOfTheWeekProvider =
    StateNotifierProvider<FirstDayOfTheWeek, String>((ref) {
  return FirstDayOfTheWeek();
});
