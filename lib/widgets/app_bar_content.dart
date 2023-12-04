import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/isSearchingProvider.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/providers/toDo_provider.dart';
import 'package:to_do_app/screens/settings.dart';

enum MenuAction { settings, about, rate }

class AppBarContent extends ConsumerStatefulWidget {
  const AppBarContent({super.key});

  @override
  ConsumerState<AppBarContent> createState() => _AppBarContentState();
}

class _AppBarContentState extends ConsumerState<AppBarContent> {
  List<ToDo>? searchTaskName(String value, List<ToDo> listOfToDo) {
    final listOfTaskNames =
        listOfToDo.where((element) => element.taskName == value).toList();
    return listOfTaskNames;
  }

  void updateSearchingValue(bool value) {
    ref.watch(searchingProvider.notifier).setSearching(value);
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(searchingProvider);

    // listens for changes and updates the variables
    final theme = ref.watch(settingsProvider);
    final listOfToDo = ref.watch(listManipulatorProvider);
    // sets boolean variable for isSearching
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
        )
      ],
    );

    TextEditingController searchBarTextField = TextEditingController(text: '');
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
                            if ((searchBarTextField.text == "")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 1),
                                      content:
                                          Text("You must enter some text")));
                              return;
                            }

                            searchTaskName(searchBarTextField.text, listOfToDo);
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
