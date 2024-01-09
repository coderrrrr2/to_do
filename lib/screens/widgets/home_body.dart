import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/services/sqflite/sqflite_service.dart';
import 'package:to_do_app/theme/color_scheme.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/searched_initiated_provider.dart';
import 'package:to_do_app/providers/searced_todo_provider.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/to_do_provider.dart';
import 'package:to_do_app/screens/edit_toDo.dart';
import 'package:to_do_app/screens/widgets/toDo_tile.dart';

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({super.key});

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  late List<String> headerName;

  @override
  void initState() {
    super.initState();
    headerName = generateHeaders();
  }

  List<String> generateHeaders() {
    DateTime currentDate = DateTime.now();
    DateTime nextWeek = currentDate.add(const Duration(days: 7));
    DateTime nextMonth = currentDate.add(const Duration(days: 30));

    return [
      if (currentDate.isBefore(nextWeek)) "Due This Week",
      if (currentDate.isBefore(nextMonth)) "Due Next Week",
      if (nextMonth.month == currentDate.month) "Due Later This Month",
      if (nextMonth.month != currentDate.month) "Due Next Month",
      "Due Later"
    ];
  }

  String formatDateRange(DateTime startDate, DateTime? endDate) {
    final startDateFormat = DateFormat.yMMMd().format(startDate);
    final endDateFormat =
        endDate != null ? DateFormat.yMMMd().format(endDate) : "onwards";
    return "$startDateFormat - $endDateFormat";
  }

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
                cancelButton(),
                finishButton(),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Finish task '),
              content: const Text('Are you sure?'),
              actions: [
                cancelButton(),
                finishButton(),
              ],
            ),
          ));
  }

  Widget cancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, false);
      },
      child: const Text('Cancel'),
    );
  }

  Widget finishButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context, true);
      },
      child: const Text('Finish'),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodiesList = [];
    final isSearchButtonPressed = ref.watch(isSearchInitiatedProvider);
    final searchedToDo = ref.watch(searchedToDoProvider);
    final listOfToDo = ref.watch(toDoProvider);
    final theme = ref.watch(settingsProvider);

    Widget body = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    SqfLiteService().deleteFromDataBase(todo);
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
          bodiesList.add(Column(
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
        itemCount: bodiesList.length,
        itemBuilder: (context, index) {
          return bodiesList[index];
        },
      );
    }
    if (isSearchButtonPressed) {
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
    return SafeArea(child: body);
  }
}
