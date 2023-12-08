// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/toDo_provider.dart';

final formatter = DateFormat.yMd();

class ToDoDetails extends ConsumerStatefulWidget {
  const ToDoDetails({super.key, required this.todo, required this.index});

  final ToDo todo;
  final int index;

  @override
  ConsumerState<ToDoDetails> createState() => _ToDoDetailsState();
}

class _ToDoDetailsState extends ConsumerState<ToDoDetails> {
  late String formattedTime;
  TextEditingController? taskController;
  List<String> repeatDaysChoices = [
    "No",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "Everyday"
  ];
  Color darkHeaderColour = const Color.fromARGB(255, 156, 81, 231);
  final formKey = GlobalKey<FormState>();
  DateTime? enteredDate;
  bool textformKeyIsEmpty = true;
  late String repeatDays;
  bool isDateSelected = false;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    taskController = TextEditingController(text: widget.todo.taskName);
    taskController!.addListener(updateIfEmpty);
    selectedTime = widget.todo.time;
    formattedTime = formatTime(widget.todo.time);
    enteredDate = widget.todo.date;
    repeatDays = widget.todo.repeatTaskDays;
  }

  @override
  void dispose() {
    taskController!.dispose();
    super.dispose();
  }

  void showDatePickerDialog() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year + 18, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(
      () {
        enteredDate = pickedDate;
      },
    );
  }

  void showTimePickerDialog() async {
    final pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    setState(
      () {
        selectedTime = pickedTime;
      },
    );
    formattedTime = formatTime(selectedTime!);
  }

  void submitForm(ToDo todo) {
    final newToDo = todo;
    ref.read(listManipulatorProvider.notifier).remove(widget.todo);
    ref.read(listManipulatorProvider.notifier).editToDo(newToDo, widget.index);

    Navigator.of(context).pop();
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
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 30),
                          child: Text(
                            "What is to be done",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.isLightMode
                                    ? Theme.of(context).colorScheme.primary
                                    : darkHeaderColour),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30,
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        style: TextStyle(
                          color: theme.isLightMode == true
                              ? Colors.black
                              : Colors.white,
                        ),
                        controller: taskController,
                        decoration: InputDecoration(
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
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Due Date",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.isLightMode
                                    ? Theme.of(context).colorScheme.primary
                                    : darkHeaderColour),
                          ),
                        ),
                      ],
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
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Due Time",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.isLightMode
                                    ? Theme.of(context).colorScheme.primary
                                    : darkHeaderColour),
                          ),
                        ),
                      ],
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
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Repeat",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.isLightMode
                                    ? Theme.of(context).colorScheme.primary
                                    : darkHeaderColour),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            width: 200,
                            margin: const EdgeInsets.all(15),
                            child: Text(
                              repeatDays,
                              style: TextStyle(
                                color: theme.isLightMode
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            )),
                        const Spacer(),
                        DropdownButtonHideUnderline(
                            child: DropdownButton(
                                dropdownColor: theme.isLightMode
                                    ? Colors.white
                                    : Colors.black,
                                items: repeatDaysChoices
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item, child: Text(item)))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    repeatDays = value!;
                                  });
                                })),
                        const SizedBox(
                          width: 15,
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
                          time: selectedTime!,
                          repeatTaskDays: repeatDays));
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
