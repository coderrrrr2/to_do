import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/isButtonPressedProvider.dart';
import 'package:to_do_app/providers/is_searching_provider.dart';
import 'package:to_do_app/providers/searced_todo_provider.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/toDoProvider.dart';
import 'package:to_do_app/screens/settings.dart';

enum MenuAction { settings, about, rate }

class AppBarContent extends ConsumerStatefulWidget {
  const AppBarContent({
    super.key,
  });

  @override
  ConsumerState<AppBarContent> createState() => _AppBarContentState();
}

class _AppBarContentState extends ConsumerState<AppBarContent> {
  TextEditingController searchBarTextField = TextEditingController(text: '');

  @override
  void dispose() {
    searchBarTextField.dispose();
    super.dispose();
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    (
      Platform.isIOS
          ? showCupertinoDialog<bool>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Tasks'),
                content: const Text('No task matches your search'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ),
            )
          : showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Tasks'),
                  content: const Text('No task matches your search'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok'),
                    ),
                  ],
                );
              },
            ),
    );
  }

  List<ToDo> returnSearchedTasks(String value, List<ToDo> listOfToDo) {
    return listOfToDo.where((element) => element.taskName == value).toList();
  }

  void updateSearchingValue(bool value) {
    ref.watch(searchingProvider.notifier).setSearching(value);
  }

  void showErroMessageIfTextEmpty() {
    if ((searchBarTextField.text == "")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 380),
          content: Text("You must enter some text")));
      return;
    }
  }

  void passListToHomeScreen(
      {required bool isButtonPressed, required List<ToDo> listOfToDo}) {
    var searchedToDo = returnSearchedTasks(searchBarTextField.text, listOfToDo);
    if (searchedToDo.isEmpty && searchBarTextField.text != "") {
      _showAlertDialog(context);
      return;
    }
    ref.read(searchedToDoProvider.notifier).set(searchedToDo);
    if (!isButtonPressed && searchedToDo.isNotEmpty) {
      ref.read(buttonPressedProvider.notifier).setSearching(!isButtonPressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    // listens for changes and updates the variables

    final isSearching = ref.watch(searchingProvider);
    final isButtonPressed = ref.watch(buttonPressedProvider);
    final theme = ref.watch(settingsProvider);
    final listOfToDo = ref.watch(listManipulatorProvider);

    // clears textfield when searching is closed
    if (!isSearching) {
      searchBarTextField.clear();
    }

    Widget appBarContent = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              updateSearchingValue(!isSearching);
            },
            icon: const Icon(Icons.search)),
        PopupMenuButton<MenuAction>(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: MenuAction.settings,
                child: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ));
                },
              ),
              const PopupMenuItem(
                value: MenuAction.about,
                child: Text('About Us'),
              ),
              const PopupMenuItem(
                value: MenuAction.rate,
                child: Text('Rate Us'),
              ),
            ];
          },
        ),
      ],
    );

    return isSearching
        ? appBarContent = Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            showErroMessageIfTextEmpty();
                            passListToHomeScreen(
                                isButtonPressed: isButtonPressed,
                                listOfToDo: listOfToDo);
                          },
                          icon: const Icon(Icons.search)),
                      SizedBox(
                        height: 50,
                        width: 300,
                        child: TextField(
                          controller: searchBarTextField,
                          style: TextStyle(
                            color: theme.isLightMode == true
                                ? Colors.black
                                : Colors.white,
                          ),
                          decoration: InputDecoration(
                            fillColor: theme.isLightMode == true
                                ? Colors.black
                                : Colors.white,
                            hintText: 'Search...',
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          )
        : appBarContent;
  }
}
