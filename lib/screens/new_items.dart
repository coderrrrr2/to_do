import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/toDo_provider.dart';

final formatter = DateFormat.yMd();

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final formKey = GlobalKey<FormState>();
  final taskController = TextEditingController();
  String enteredTask = '';
  DateTime? enteredDate;
  bool textformKeyIsEmpty = true;

  void showDatePickerDialog() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      enteredDate = pickedDate;
    });
  }

  void submitformKey(ToDo todo) {
    log(enteredDate.toString());
    ref.read(listManipulatorProvider.notifier).add(todo);
    Navigator.of(context).pop();
  }

  void updateEmpty() {
    setState(() {
      textformKeyIsEmpty = taskController.text.isEmpty;
    });
  }

  @override
  void initState() {
    taskController.addListener(updateEmpty);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Task'),
        ),
        body: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        labelText: "What is meant to be done",
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        enteredTask = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 322,
                        margin: const EdgeInsets.all(15),
                        child: Text(enteredDate == null
                            ? "Date Not Set"
                            : formatter.format(enteredDate!)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: showDatePickerDialog,
                          icon: const Icon(Icons.calendar_month))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: !textformKeyIsEmpty
            ? FloatingActionButton(
                onPressed: () {
                  if (enteredDate != null) {
                    submitformKey(
                        ToDo(taskName: enteredTask, date: enteredDate!));
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("You must pick a date")));
                },
                child: const Icon(Icons.check),
              )
            : null);
  }
}
