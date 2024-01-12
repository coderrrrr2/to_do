import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_app/providers/settings_provider.dart';
import 'package:to_do_app/services/sharedPreferences/shared_preferences_service.dart';
import 'package:to_do_app/services/sqflite/sqflite_service.dart';
import 'package:to_do_app/models/settings.dart';
import 'package:to_do_app/models/to_do.dart';
import 'package:to_do_app/providers/searched_initiated_provider.dart';
import 'package:to_do_app/providers/is_searching_provider.dart';
import 'package:to_do_app/providers/searched_date_provider.dart';
import 'package:to_do_app/providers/to_do_provider.dart';
import 'package:to_do_app/screens/add_new_todo.dart';
import 'package:to_do_app/screens/date_screen.dart';
import 'package:to_do_app/screens/widgets/app_bar_content.dart';
import 'package:to_do_app/screens/widgets/home_body.dart';

// enum for the settings value

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Widget body = const HomeBody();
  Widget appBarContent = const AppBarContent();

  late Future<void> todoFuture;
  late Future<Settings> settingsFuture;
  late Future<void> loadingFuture;

  @override
  void initState() {
    super.initState();
    settingsFuture = SharedPreferencesService().load();
    todoFuture = SqfLiteService().loadPlaces();
    loadingFuture = Future.wait([todoFuture, settingsFuture]);
    ref.read(toDoProvider.notifier).set();
    ref.read(settingsProvider.notifier).set();
  }

  void updateIfSearchingValue(bool value) {
    ref.watch(isSearchingProvider.notifier).setSearching(value);
  }

  void setIfSearchButtonPressedValue(bool value) {
    ref.read(isSearchInitiatedProvider.notifier).setSearching(value);
  }

  List<ToDo> getToDos() {
    return ref.watch(toDoProvider);
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

  Future<DateTime?> showDatePickerDialog() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year + 18, now.month, now.day);

    return await showDatePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
      fieldLabelText: 'Select date ',
      helpText: 'Which day do you want to search for',
    );
  }

  List<ToDo> getSearchedDateToDos(DateTime date) {
    final todo = getToDos();
    return todo.where((element) => element.date == date).toList();
  }

  void showDateScreen() async {
    var dateSelected = await showDatePickerDialog();
    if (dateSelected != null) {
      var searchedToDos = getSearchedDateToDos(dateSelected);
      ref.read(searchedDateProvider.notifier).set(searchedToDos);
      if (searchedToDos.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DateScreen(
              date: dateSelected,
            ),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        _showAlertDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            actions: [appBarContent],
            leading: isSearching
                ? IconButton(
                    onPressed: () {
                      updateIfSearchingValue(!isSearching);
                      setIfSearchButtonPressedValue(false);
                    },
                    icon: const Icon(Icons.arrow_back_sharp))
                : IconButton(
                    onPressed: showDateScreen,
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 35,
                    )),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TasksScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add)),
          body: FutureBuilder(
              future: loadingFuture,
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SafeArea(
                        child: body,
                      );
              }),
        ));
  }
}
