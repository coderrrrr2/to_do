// ignore_for_file: file_names
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/to_do_provider.dart';

final formatter = DateFormat.yMd();

Map<int, String> weekdayMap = {
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thur',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};

class ToDoTile extends ConsumerStatefulWidget {
  const ToDoTile({
    super.key,
    required this.todo,
  });

  final ToDo todo;
  @override
  ConsumerState<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends ConsumerState<ToDoTile> {
  String formatTime(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  void setIsCheckedValue(bool? value) {
    int index = ref.read(toDoProvider.notifier).getIndex(widget.todo);
    if (index >= 0) {
      var currentTodo = widget.todo;
      ref.read(toDoProvider.notifier).editToDo(
          oldtodo: currentTodo,
          newtodo: ToDo(
              taskName: currentTodo.taskName,
              date: currentTodo.date,
              time: currentTodo.time,
              isChecked: value,
              repeatTaskDays: currentTodo.repeatTaskDays),
          index: index);
    }
    setState(() {
      widget.todo.isChecked = value!;
    });
  }

  Future<bool> returnTodoStatus() async {
    return await (Platform.isIOS
        ? showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Finish task '),
              content: const Text('Are you sure?'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Finish'),
                ),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Finish task '),
              content: const Text('Are you sure?'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Finish'),
                ),
              ],
            ),
          ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(settingsProvider);

    return Container(
      margin: const EdgeInsets.all(10),
      width: 380,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                    key: Key(widget.todo.id),
                    value: widget.todo.isChecked,
                    onChanged: (value) {
                      setIsCheckedValue(value);
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.todo.taskName,
                      style: TextStyle(
                        color: theme.isLightMode == true
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text("${weekdayMap[widget.todo.date.weekday]},",
                            style: TextStyle(
                              color: theme.isLightMode == true
                                  ? Colors.black
                                  : Colors.white,
                            )),
                        Text(
                            formatTime(
                              widget.todo.time,
                            ),
                            style: TextStyle(
                              color: theme.isLightMode == true
                                  ? Colors.black
                                  : Colors.white,
                            )),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
