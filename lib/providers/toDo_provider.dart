import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:to_do_app/models/to_do.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

bool isSearching = false;

Future<Database> getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final database = await sql.openDatabase(
    path.join(dbPath, 'TodoDb'),
    onCreate: (dbInstance, version) async {
      await dbInstance.execute(
        "CREATE TABLE user_todo(id TEXT PRIMARY KEY, task TEXT, time TEXT, date DATETIME)",
      );

      await dbInstance.execute(
        "CREATE TABLE user_settings(isNotifications BOOL, isLightMode BOOL, chosenLanguage TEXT, timeFormat TEXT)",
      );
    },
  );
  return database;
}

class ListManipulator extends StateNotifier<List<ToDo>> {
  ListManipulator() : super([]);

  void add(ToDo todo) {
    state = [...state, todo];
  }

  void remove(ToDo todo) {
    state = state.where((element) => element != todo).toList();
  }
}

final listManipulatorProvider =
    StateNotifierProvider<ListManipulator, List<ToDo>>((ref) {
  return ListManipulator();
});
