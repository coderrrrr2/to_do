import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/toDo_provider.dart';
import 'package:to_do_app/screens/settings.dart';
import 'package:to_do_app/screens/new_items.dart';
import 'package:to_do_app/widgets/toDo_tile.dart';

// enum for the settings value
enum MenuAction { settings, about, rate }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isSearching = false;
  Widget? appBarContent;

  @override
  void initState() {
    super.initState();
    ref.read(listManipulatorProvider.notifier).getDataBase();
  }

  bool isChecked = false;

  void removeToDo(ToDo todo) {
    ref.read(listManipulatorProvider.notifier).remove(todo);
  }

  void addToDo(ToDo todo) {
    ref.read(listManipulatorProvider.notifier).add(todo);
  }

  Future<bool> returnTodoStatus() async {
    return await showDialog(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final listOfToDo = ref.watch(listManipulatorProvider);
    appBarContent = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
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
            child: Dismissible(
              key: Key(listOfToDo[index].id),
              onDismissed: (direction) async {
                removeToDo(listOfToDo[index]);
              },
              direction: DismissDirection.horizontal,
              // movementDuration: const Duration(milliseconds: 900),
              confirmDismiss: (direction) async => await returnTodoStatus(),
              dismissThresholds: const {
                DismissDirection.startToEnd: 0.6,
                DismissDirection.endToStart: 0.6,
              },
              child: ToDoTile(
                task: listOfToDo[index].taskName,
                time: listOfToDo[index].time,
                id: listOfToDo[index].id,
              ),
            ),
          );
        },
      );
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [
              isSearching
                  ? appBarContent = Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.search)),
                                const SizedBox(
                                  height: 50,
                                  width: 300,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
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
                  : appBarContent!
            ],
            leading: isSearching
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                    icon: const Icon(Icons.arrow_back_sharp))
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 35,
                    )),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TasksScreen(),
                ));
              },
              child: const Icon(Icons.add)),
          body: SafeArea(child: body)),
    );
  }
}
