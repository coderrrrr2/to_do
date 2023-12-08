import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/isSearchingProvider.dart';
import 'package:to_do_app/providers/toDo_provider.dart';
import 'package:to_do_app/screens/edit_toDo.dart';
import 'package:to_do_app/widgets/toDo_tile.dart';

class HomeBody extends ConsumerStatefulWidget {
  HomeBody({super.key, List<ToDo>? searchedToDo})
      : searchedToDo = searchedToDo ?? [];
  final List<ToDo>? searchedToDo;

  @override
  ConsumerState<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  void removeToDo(ToDo todo) {
    ref.read(listManipulatorProvider.notifier).remove(todo);
  }

  void addToDo(ToDo todo) {
    ref.read(listManipulatorProvider.notifier).add(todo);
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
  Widget build(BuildContext context) {
    final listOfToDo = ref.watch(listManipulatorProvider);
    final isSearching = ref.watch(searchingProvider);

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
      body = ListView.builder(
        itemCount: listOfToDo.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ToDoDetails(
                  todo: listOfToDo[index],
                  index: index,
                ),
              )),
              child: Dismissible(
                key: Key(listOfToDo[index].id),
                onDismissed: (direction) async {
                  removeToDo(listOfToDo[index]);
                },
                direction: DismissDirection.horizontal,
                movementDuration: const Duration(milliseconds: 900),
                confirmDismiss: (direction) async => await returnTodoStatus(),
                dismissThresholds: const {
                  DismissDirection.startToEnd: 0.6,
                  DismissDirection.endToStart: 0.6,
                },
                child: ToDoTile(
                  todo: listOfToDo[index],
                ),
              ),
            ),
          );
        },
      );
    }
    if (isSearching && widget.searchedToDo!.isNotEmpty) {
      body = ListView.builder(
        itemCount: widget.searchedToDo!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ToDoDetails(
                  todo: widget.searchedToDo![index],
                  index: index,
                ),
              )),
              child: Dismissible(
                key: Key(widget.searchedToDo![index].id),
                onDismissed: (direction) async {
                  removeToDo(widget.searchedToDo![index]);
                },
                direction: DismissDirection.horizontal,
                movementDuration: const Duration(milliseconds: 900),
                confirmDismiss: (direction) async => await returnTodoStatus(),
                dismissThresholds: const {
                  DismissDirection.startToEnd: 0.6,
                  DismissDirection.endToStart: 0.6,
                },
                child: ToDoTile(
                  todo: widget.searchedToDo![index],
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
