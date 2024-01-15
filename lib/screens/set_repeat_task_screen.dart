import 'package:flutter/material.dart';
import 'package:to_do_app/screens/widgets/repeat_task_container.dart';

class RepeatTaskScreen extends StatefulWidget {
  const RepeatTaskScreen({super.key});

  @override
  State<RepeatTaskScreen> createState() => _RepeatTaskScreenState();
}

class _RepeatTaskScreenState extends State<RepeatTaskScreen> {
  List<String> repeatDaysChoices = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repeat"),
      ),
      body: ListView.builder(
        itemCount: repeatDaysChoices.length,
        itemBuilder: (context, index) {
          return TaskContainer(
            leadingText: repeatDaysChoices[index],
          );
        },
      ),
    );
  }
}
