import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/color_scheme.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/searched_button_provider.dart';
import 'package:to_do_app/providers/searced_todo_provider.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/to_do_provider.dart';
import 'package:to_do_app/screens/edit_toDo.dart';
import 'package:to_do_app/widgets/toDo_tile.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  List<String> headerName = [
    "Due This Week",
    "Due Next Week",
    "Due Later This Month",
    "Due Next Month",
    "Due Later"
  ];
  void removeToDo(ToDo todo) {
    ref.read(toDoProvider.notifier).remove(todo);
  }

  void addToDo(ToDo todo) {
    ref.read(toDoProvider.notifier).add(todo);
  }

  void removeSearchedToDo(ToDo todo) {
    ref.read(searchedToDoProvider.notifier).remove(todo);
  }

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

  @override
  Widget build(BuildContext context) {
    List<Widget> bodys = [];
    final isButtonPressed = ref.watch(buttonPressedProvider);
    final searchedToDo = ref.watch(searchedToDoProvider);
    final listOfToDo = ref.watch(toDoProvider);
    final theme = ref.watch(settingsProvider);

    Widget body = Padding(
      padding: const EdgeInsets.only(
        top: 300,
        left: 150,
        right: 100,
      ),
      child: Column(
        children: [
          Image.asset('assets/images/fluent-mdl2_vacation.png'),
          const SizedBox(
            height: 10,
          ),
          Image.asset('assets/images/Nothing to do.png')
        ],
      ),
    );

    if (listOfToDo.isNotEmpty) {
      for (int i = 0; i < headerName.length; i++) {
        String header = headerName[i];

        final editedList = listOfToDo
            .where((element) => element.taskDayClassification == header)
            .toList();
        if (editedList.isNotEmpty) {
          // Create a list of
          List<Widget> todoWidgets = editedList.map((todo) {
            final index = editedList.indexOf(todo); // Get the index directly

            return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditToDo(todo: todo, index: index),
              )),
              child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                ),
                child: Dismissible(
                  key: Key(todo.id),
                  onDismissed: (direction) {
                    removeToDo(todo);
                    ref.read(searchedToDoProvider.notifier).remove(todo);
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
                    todo: todo,
                  ),
                ),
              ),
            );
          }).toList();

          // Add the header and the list of to-do item widgets to the body
          bodys.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.only(left: 25, top: 10),
                  child: Text(header,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.isLightMode
                              ? Theme.of(context).colorScheme.primary
                              : darkHeaderColour))),
              ...todoWidgets, // Use the spread operator to add the list of to-do item widgets
            ],
          ));
        }
      }
      body = ListView.builder(
        itemCount: bodys.length,
        itemBuilder: (context, index) {
          return bodys[index];
        },
      );
    }
    if (isButtonPressed) {
      body = ListView.builder(
        itemCount: searchedToDo.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditToDo(
                  todo: searchedToDo[index],
                  index: index,
                ),
              )),
              child: Dismissible(
                key: Key(searchedToDo[index].id),
                onDismissed: (direction) {
                  var currentToDo = searchedToDo[index];
                  removeSearchedToDo(searchedToDo[index]);
                  removeToDo(currentToDo);
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
                  todo: searchedToDo[index],
                ),
              ),
            ),
          );
        },
      );
    }
    return body;
  }
}
