import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/toDo_provider.dart';

final formatter = DateFormat.yMd();

class ToDoDetails extends ConsumerStatefulWidget {
  const ToDoDetails({super.key, required this.todo});

  final ToDo todo;

  @override
  ConsumerState<ToDoDetails> createState() => _ToDoDetailsState();
}

class _ToDoDetailsState extends ConsumerState<ToDoDetails> {
  late String formattedTime;
  TextEditingController? taskController;

  final formKey = GlobalKey<FormState>();

  DateTime? enteredDate;

  bool textformKeyIsEmpty = true;

  bool isDateSelected = false;

  TimeOfDay? selectedTime;

  void showDatePickerDialog() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year + 18, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      enteredDate = pickedDate;
    });
  }

  void showTimePickerDialog() async {
    final pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    setState(() {
      selectedTime = pickedTime;
    });
    formattedTime = formatTime(selectedTime!);
  }

  void submitForm(ToDo todo) {
    final newToDo = todo;
    ref.read(listManipulatorProvider.notifier).remove(widget.todo);
    ref.read(listManipulatorProvider.notifier).add(newToDo);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    taskController = TextEditingController(text: widget.todo.taskName);
    taskController!.addListener(updateIfEmpty);
    selectedTime = widget.todo.time;
    formattedTime = formatTime(widget.todo.time);
    enteredDate = widget.todo.date;
    log(" $enteredDate is the entered date");
    super.initState();
  }

  void updateIfEmpty() {
    setState(() {
      textformKeyIsEmpty = taskController!.text.isEmpty;
    });
  }

  String formatTime(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    taskController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(settingsProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("Edit Task"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        style: TextStyle(
                          color: theme.isLightMode == true
                              ? Colors.black
                              : Colors.white,
                        ),
                        controller: taskController,
                        decoration: InputDecoration(
                          labelText: "What is meant to be done",
                          labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 322,
                          margin: const EdgeInsets.all(15),
                          child: Text(
                            formatter.format(enteredDate!),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .color),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: showDatePickerDialog,
                          icon: const Icon(Icons.calendar_month),
                          color: theme.isLightMode == true
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(15),
                          width: 300,
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .color),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: showTimePickerDialog,
                          icon: const Icon(Icons.timelapse),
                          color: theme.isLightMode == true
                              ? Colors.black
                              : Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: !textformKeyIsEmpty ||
                  taskController!.text.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () {
                    if (enteredDate != null && selectedTime != null) {
                      submitForm(ToDo(
                          taskName: taskController!.text,
                          date: enteredDate!,
                          time: selectedTime!));
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("You must select all options")));
                  },
                  child: const Icon(Icons.check),
                )
              : null),
    );
  }
}
