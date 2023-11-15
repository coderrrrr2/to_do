import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final listOfToDo = ref.watch(listManipulatorProvider);
    Widget body = Padding(
      padding: const EdgeInsets.only(
        top: 300,
        left: 150,
        right: 100,
      ),
      child: Image.asset('assets/images/fluent-mdl2_vacation.png'),
    );
    if (listOfToDo.isNotEmpty) {
      body = ListView.builder(
        itemCount: listOfToDo.length,
        itemBuilder: (context, index) {
          return const ToDoTile();
        },
      );
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
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
          leading: IconButton(
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
        body: body);
  }
}
