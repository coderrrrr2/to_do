import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/searched_date_provider.dart';
import 'package:to_do_app/providers/to_do_provider.dart';
import 'package:to_do_app/screens/edit_toDo.dart';
import 'package:to_do_app/screens/widgets/toDo_tile.dart';

final formatter = DateFormat.yMd();

class DateScreen extends ConsumerStatefulWidget {
  const DateScreen({super.key, required this.date});
  final DateTime date;

  @override
  ConsumerState<DateScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<DateScreen> {
  Future<bool> alertDialogForListTile() async {
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

  void removeToDo(ToDo todo) {
    ref.read(toDoProvider.notifier).remove(todo);
  }

  void addToDo(ToDo todo) {
    ref.read(toDoProvider.notifier).add(todo);
  }

  @override
  Widget build(BuildContext context) {
    final searchedToDos = ref.watch(searchedDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(" Tasks for ${formatter.format(widget.date)}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: searchedToDos.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditToDo(
                    todo: searchedToDos[index],
                    index: index,
                  ),
                )),
                child: Dismissible(
                  key: Key(searchedToDos[index].id),
                  onDismissed: (direction) {
                    removeToDo(searchedToDos[index]);
                  },
                  direction: DismissDirection.horizontal,
                  movementDuration: const Duration(milliseconds: 900),
                  confirmDismiss: (direction) async =>
                      await alertDialogForListTile(),
                  dismissThresholds: const {
                    DismissDirection.startToEnd: 0.6,
                    DismissDirection.endToStart: 0.6,
                  },
                  child: ToDoTile(
                    todo: searchedToDos[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
