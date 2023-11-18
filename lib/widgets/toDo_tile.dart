// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class ToDoTile extends StatefulWidget {
  const ToDoTile(
      {super.key, required this.task, required this.time, required this.id});

  final String task;
  final TimeOfDay time;
  final String id;

  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

bool isChecked = false;

class _ToDoTileState extends State<ToDoTile> {
  String formatTime(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 200,
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
                  key: Key(widget.id),
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                      log(widget.task);
                    });
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text(widget.task), Text(formatTime(widget.time))],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
